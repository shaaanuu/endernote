import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/notes/note_bloc.dart';
import '../../../bloc/notes/note_events.dart';
import '../../../bloc/notes/note_states.dart';
import 'edit_mode/edit_mode.dart';
import 'preview_mode/preview_mode.dart';

class ScreenCanvas extends StatelessWidget {
  ScreenCanvas({super.key});

  final ValueNotifier editOrPreview = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteBlocState>(
      builder: (context, state) {
        String noteTitle = "";

        if ((state.noteTitleController?.text.isEmpty ?? true)) {
          String firstLine =
              (state.noteTextController?.text.split("\n").first ?? "");
          if (firstLine.length >= 10) {
            noteTitle = state.noteTextController?.text.substring(0, 10) ?? "";
          } else {
            noteTitle = firstLine;
          }
        } else {
          noteTitle = state.noteTitleController?.text ?? "";
        }

        return ValueListenableBuilder(
          valueListenable: editOrPreview,
          builder: (context, value, _) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if ((state.noteTextController?.text ?? "") == "") {
                      context.read<NoteBloc>().add(
                            DeleteNote(noteId: state.currentNote?.uuid ?? ""),
                          );
                    } else {
                      context.read<NoteBloc>().add(SaveNoteChanges());
                    }

                    Navigator.pop(context);
                  },
                  icon: const Icon(IconsaxOutline.arrow_left_2),
                ),
                title: value
                    ? TextField(
                        controller: state.noteTitleController ??
                            TextEditingController(),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        noteTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                actions: [
                  IconButton(
                    icon: Icon(
                      value ? IconsaxOutline.edit_2 : IconsaxOutline.book_1,
                    ),
                    onPressed: () {
                      if ((state.noteTextController?.text ?? "") != "") {
                        context.read<NoteBloc>().add(SaveNoteChanges());
                      }

                      editOrPreview.value = !editOrPreview.value;
                    },
                  ),
                ],
              ),
              body: value
                  ? EditMode(
                      entityPath: ModalRoute.of(context)?.settings.arguments
                              as String? ??
                          "",
                    )
                  : PreviewMode(
                      entityPath: ModalRoute.of(context)?.settings.arguments
                              as String? ??
                          "",
                    ),
            );
          },
        );
      },
    );
  }
}
