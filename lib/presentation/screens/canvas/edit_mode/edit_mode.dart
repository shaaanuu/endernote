import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/notes/note_bloc.dart';
import '../../../../bloc/notes/note_states.dart';

class EditMode extends StatefulWidget {
  const EditMode({super.key, this.entityPath});

  final String? entityPath;

  @override
  State<EditMode> createState() => _EditModeState();
}

class _EditModeState extends State<EditMode> {
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteBlocState>(
      builder: (context, state) {
        focusNode.requestFocus();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black12,
            child: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: state.noteTextController ?? TextEditingController(text: widget.entityPath),
              expands: true,
              minLines: null,
              maxLines: null,
            ),
          ),
        );
      },
    );
  }
}
