require "aws-sdk-s3"

class YandexCloudService
  def initialize
    @s3 = Aws::S3::Resource.new(
      access_key_id: ENV["YANDEX_CLOUD_ACCESS_KEY"],
      secret_access_key: ENV["YANDEX_CLOUD_SECRET_KEY"],
      region: "ru-central1",
      endpoint: "https://storage.yandexcloud.net"

    )
    @bucket = @s3.bucket(ENV["YANDEX_CLOUD_BUCKET"])
  end

  def fetch_all_tracks
    common_artwork_url = generate_artwork_url
    @bucket.objects.each do |object|
      process_track(object, nil, common_artwork_url) if object.key.match(/\.mp3$/)
    end
  end

  def process_track(object, playlist = nil, artwork_url)
    filename = object.key.split("/").last
    artist_name, name = parse_filename(filename)
    cloud_url = object.public_url
    artwork_url = generate_artwork_url

    track = Track.find_or_create_by!(
      name: name,
      artist_name: artist_name,
      cloud_url: cloud_url,
      kind: "track",
      artwork_url: artwork_url
    )

      if track.artwork_url.blank?
        track.update!(artwork_url: artwork_url)
      end

      if playlist
        playlist.tracks << track unless playlist.tracks.include?(track)
      end
  end

  def fetch_all_playlists
    common_artwork_url = generate_artwork_url
    @bucket.objects(prefix: "playlists/").each do |object|
      process_playlist(object, common_artwork_url) if object.key.match(/playlists\/[^\/]+\/[^\/]+.mp3$/)
    end
  end

  def process_playlist(object, common_artwork_url)
    playlist_name = object.key.split("/")[1]
    default_kind = "playlist"
    artwork_url = common_artwork_url
    url = object.public_url

    playlist = Playlist.find_or_create_by!(
      name: playlist_name
    ) do |pl|
      pl.kind = default_kind
      pl.artwork_url = common_artwork_url
      pl.url = url
     end

    @bucket.objects(prefix: "playlists/#{playlist_name}/").each do |track_object|
      process_track(track_object, playlist, artwork_url) if track_object.key.match(/\.mp3$/)
    end
  end

  def parse_filename(filename)
    base_name = File.basename(filename, File.extname(filename)) # delete .mp3

    if base_name.include?(" - ")
      artist_name, name = base_name.split(" - ", 2)
    else
      artist_name = "Unknown Artist"
      name = base_name
    end

    [ artist_name.strip, name.strip ]
  end

  def generate_artwork_url # Возвращаем URL обложки
    "https://storage.yandexcloud.net/music-servise-bucker1/artwork.jpg"
  end
end
