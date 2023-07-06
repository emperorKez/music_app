// ignore_for_file: public_member_api_docs, sort_constructors_first

 final List<Song> songlist = [
    Song(title: 'You are right', artiste: 'Doja Cat', artwork: 'assets/images/image4.png', duration: 3.58),
    Song(title: '2 AM', artiste: 'Arizona Zervas', artwork: 'assets/images/image5.png', duration: 3.03)
,Song(title: 'Baddest', artiste: '2 Chainz, Chris Brown', artwork: 'assets/images/image6.png', duration: 3.51),
Song(title: 'True Love', artiste: 'Kanye West', artwork: 'assets/images/image7.png', duration: 4.52)
,
Song(title: 'Bye Bye', artiste: 'mashmello, Juice Wirld', artwork: 'assets/images/image8.png', duration: 2.06)
,
Song(title: 'hands on you', artiste: 'Austin George', artwork: 'assets/images/image9.png', duration: 3.56)
  ];

 final List<Song> favouriteSongs = [
Song(title: 'Bye Bye', artiste: 'mashmello, Juice Wirld', artwork: 'assets/images/image1.png', duration: 2.06),
Song(title: 'I Like You', artiste: 'Post Malone, Doja Cat', artwork: 'assets/images/image2.png', duration: 4.03),
Song(title: 'Fountains', artiste: 'Drake, Tems', artwork: 'assets/images/image3.png', duration: 3.18)
  ];

final List<Playlist> playlists =[Playlist(artwork: 'assets/images/image11.png', title: 'top 50'),
Playlist(artwork: 'assets/images/image10.png', title: 'Chill'),
Playlist(artwork: 'assets/images/image11.png', title: 'R&B'),
Playlist(artwork: 'assets/images/image10.png', title: 'Festival'),
Playlist(artwork: 'assets/images/image11.png', title: 'Dance Hall')];

class Playlist {
  final String artwork;
  final String title;
  Playlist({
    required this.artwork,
    required this.title,
  });
}
class Song {
  final String title;
  final String artiste;
  final String artwork;
  final double duration;
  Song({
    required this.title,
    required this.artiste,
    required this.artwork,
    required this.duration
  });
}

 