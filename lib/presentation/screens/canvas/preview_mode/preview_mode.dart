import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../bloc/notes/note_bloc.dart';
import '../../../../bloc/notes/note_states.dart';
import '../../../theme/markdown_theme.dart';

class PreviewMode extends StatelessWidget {
  const PreviewMode({super.key, this.entityPath});

  final String? entityPath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteBlocState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Markdown(
                data: state.noteTextController?.text ?? entityPath!,
                styleSheet: mdTheme(),
              ),
            ),
          ],
        );
      },
    );
  }
}
