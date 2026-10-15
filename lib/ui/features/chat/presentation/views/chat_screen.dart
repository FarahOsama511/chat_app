import 'dart:convert';
import 'dart:developer';
import 'package:chatapp/core/di/service_locator.dart';
import 'package:chatapp/core/helpers/sharedpref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/networking/pusher_config.dart';
import '../../../../../data/models/group_model.dart';
import '../../../../../data/models/room_messages_response_model.dart';
import '../../bussiness logic/chat_cubit.dart';
import '../../bussiness logic/chat_state.dart';
import '../../bussiness logic/send_message_cubit.dart';
import '../../bussiness logic/send_message_state.dart';
import '../widgets/attachment_bottom_sheet.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';

class ChatScreen extends StatefulWidget {
  final GroupModel group;
  const ChatScreen({super.key, required this.group});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final pusherConfig = getIt<PusherConfig>();

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<MessageItemModel> _messages = [];
  // bool _isInitialLoaded = false;
  String? socketId;

  bool get _isGroup => widget.group.type == 'group';

  @override
  void initState() {
    super.initState();
    _subscribeToPusherRoom();
  }

  Future<void> _subscribeToPusherRoom() async {
    final roomId = widget.group.id;
    log(roomId.toString());
    if (roomId == null) return;
    try {
      await pusherConfig.init();
      await pusherConfig.connect();
      await pusherConfig.subscribe(
        channelName: 'private-rooms.$roomId',
        onEvent: (event) {
          log(
            'ChatScreen: Event on room $roomId -> ${event.eventName}: ${event.data}',
          );
          if (event.eventName == 'message.sent') {
            _handleIncomingPusherMessage(event);
          }
        },
      );
      final id = await pusherConfig.getSocketId();
      if (mounted) {
        setState(() {
          socketId = id;
        });
      }
    } catch (e) {
      log('ChatScreen Pusher error: $e');
    }
  }

  void _handleIncomingPusherMessage(PusherEvent event) {
    // to indicate who sent the message
    final data = jsonDecode(event.data);
    final message = data['message'];
    final senderId = data['message']['sender_id'];
    final isMe =
        SharedprefHelper.getData('user_id').toString() == senderId.toString();
    final inComingMessage = MessageItemModel.fromJson(message);
    setState(() {
      _messages.add(
        MessageItemModel(
          id: inComingMessage.id,
          message: inComingMessage.message,
          type: inComingMessage.type,
          createdAt: inComingMessage.createdAt,
          isMe: isMe,
          sender: inComingMessage.sender,
        ),
      );
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    final roomId = widget.group.id;
    if (roomId != null) {
      pusherConfig.unsubscribe(channelName: 'private-rooms.$roomId');
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) async {
    final activeSocketId = socketId ?? await pusherConfig.getSocketId() ?? "0";
    if (!mounted) return;
    context.read<SendMessageCubit>().emitSendMessage(
      widget.group.id ?? 0,
      activeSocketId,
      body: text,
      type: 'text',
    );
    _scrollToBottom();
  }

  Future<void> _handleAttachmentTap() async {
    final attachment = await AttachmentBottomSheet.show(context);
    if (attachment != null && mounted) {
      final activeSocketId =
          socketId ?? await pusherConfig.getSocketId() ?? "0";
      if (!mounted) return;
      context.read<SendMessageCubit>().emitSendMessage(
        widget.group.id ?? 0,
        activeSocketId,
        body: attachment.path,
        type: attachment.type,
      );
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatAppBar(group: widget.group),
      body: BlocListener<SendMessageCubit, SendMessageState>(
        listener: (context, state) {
          if (state is SendMessageSuccess) {
            setState(() {
              _messages.add(state.message);
            });
            _scrollToBottom();
          } else if (state is SendMessageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Messages Content Area
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatSuccess) {
                    setState(() {
                      _messages = state.messages.reversed.toList();
                    });
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.sp,
                              color: colorScheme.error,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ChatCubit>().emitGetRoomMessages(
                                  widget.group.id ?? 0,
                                );
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (_messages.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<ChatCubit>()
                          .emitGetRoomMessages(widget.group.id ?? 0),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 64.w,
                                    height: 64.h,
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 28.sp,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  Text(
                                    'No messages yet',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Send a message to start the conversation',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<ChatCubit>()
                        .emitGetRoomMessages(widget.group.id ?? 0),
                    child: ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      children: [
                        // Date marker
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              'Today',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.outlineVariant,
                                  ),
                            ),
                          ),
                        ),
                        ..._messages.map(
                          (msg) => ChatBubble(message: msg, isGroup: _isGroup),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Composer with separate SendMessageCubit state
            BlocBuilder<SendMessageCubit, SendMessageState>(
              builder: (context, state) {
                return ChatComposer(
                  isSending: state is SendMessageLoading,
                  hintText: _isGroup
                      ? 'Message the group'
                      : 'Message ${widget.group.name ?? '...'}',
                  onSend: _sendMessage,
                  onAttachmentTap: _handleAttachmentTap,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
