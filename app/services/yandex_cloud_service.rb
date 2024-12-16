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
    @bucket.objects.each do |object|
      process_track(object)
    end
  end

  def process_track(object, playlist)
    filename = object.key.split("/").last
    artist_name, name = parse_filename(filename)
    cloud_url = object.public_url

    track = Track.find_or_create_by!(
      name: name,
      artist_name: artist_name,
      cloud_url: cloud_url
    )

    playlist.tracks << track unless playlist.tracks.include?(track)
  end

  def fetch_all_playlists
    @bucket.objects(prefix: "playlists/").each do |object|
      process_playlist(object) if object.key.match(/playlists\/[^\/]+\/[^\/]+.mp3$/)
    end
  end

  def process_playlist(object)
    playlist_name = object.key.split("/")[1]
    default_kind = "playlist"
    default_artwork_url = "-"
    url = object.public_url

    playlist = Playlist.find_or_create_by!(
      name: playlist_name
    ) do |pl|
      pl.kind = default_kind
      pl.artwork_url = default_artwork_url
      pl.url = url
     end

    @bucket.objects(prefix: "playlists/#{playlist_name}/").each do |track_object|
      process_track(track_object, playlist) if track_object.key.match(/\.mp3$/)
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
end
