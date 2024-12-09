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

  def process_track(object)
    filename = object.key.split("/").last
    artist_name, name = parse_filename(filename)
    cloud_url = object.public_url
    # duration = extract_duration(object)

    Track.create!(
      name: name,
      artist_name: artist_name,
      cloud_url: cloud_url,
      # duration: duration
    )
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
