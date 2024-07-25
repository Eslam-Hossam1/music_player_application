import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubits/favourate_songs_cubit.dart/favourate_songs_cubit.dart';
import 'package:music_player_app/models/my_song_model.dart';

class CustomeFavouriteButton extends StatefulWidget {
  const CustomeFavouriteButton({
    super.key,
    required this.mySongModel,
  });
  final MySongModel mySongModel;

  @override
  State<CustomeFavouriteButton> createState() => _CustomeFavouriteButtonState();
}

class _CustomeFavouriteButtonState extends State<CustomeFavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() {
          if (widget.mySongModel.isFavourate) {
            BlocProvider.of<FavourateSongsCubit>(context)
                .removeFromFavourates(mySongModel: widget.mySongModel);
          } else {
            BlocProvider.of<FavourateSongsCubit>(context)
                .addToFavourates(mySongModel: widget.mySongModel);
          }
        });
        await widget.mySongModel.save(); // Save the change persistently
      },
      icon: widget.mySongModel.isFavourate
          ? Icon(
              Icons.favorite,
              color: Colors.red,
              size: 28,
            )
          : Icon(
              Icons.favorite_border_outlined,
              size: 28,
            ),
    );
  }
}
