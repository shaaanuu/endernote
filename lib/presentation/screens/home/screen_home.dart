import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../bloc/notes/note_bloc.dart';
import '../../../bloc/notes/note_events.dart';
import '../../../bloc/notes/note_states.dart';
import '../../../models/note_model.dart';
import '../../theme/endernote_theme.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NoteBloc>().add(LoadNotes());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxOutline.arrow_left_2),
        ),
        title: const Text(
          'All Notes',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NoteBloc, NoteBlocState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<NoteModel> reversedList = state.notes.reversed.toList();

          if (reversedList.isEmpty) {
            return const Center(
              child: Text(
                "No notes available",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: reversedList.length,
            itemBuilder: (context, index) {
              final note = reversedList[index];

              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    IconButton(
                      icon: const Icon(IconsaxOutline.trash),
                      onPressed: () {
                        context.read<NoteBloc>().add(
                              DeleteNote(noteId: note.uuid),
                            );
                      },
                    ),
                    IconButton(
                      icon: note.isFavorite
                          ? const Icon(IconsaxBold.heart)
                          : const Icon(IconsaxOutline.heart),
                      onPressed: () =>
                          context.read<NoteBloc>().add(ToggleFavorite(note),),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: clrText),
                  ),
                  child: ListTile(
                    onTap: () {
                      context.read<NoteBloc>().add(
                            ChangeNote(newNote: note),
                          );
                      Navigator.pushNamed(context, '/canvas');
                    },
                    leading: const Icon(IconsaxOutline.note),
                    title: Text(note.title),
                    subtitle: Text(
                      "${DateFormat.jm().format(note.creationDate)} on ${DateFormat('dd-MM-yyyy').format(note.creationDate)}",
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
