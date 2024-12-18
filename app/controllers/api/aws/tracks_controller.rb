module Api
  module Aws
    class TracksController < ApplicationController
      before_action :authenticate_user!, only: [ :like_track ]
      def index
        @tracks = Track.all
        render json: tracks.map { |track| format_track(track) }, status: :ok
      end

      def sync
        yandex_service = YandexCloudService.new
        yandex_service.fetch_all_tracks
        render json: { message: "Tracks synced successfully" }
      end


      def top_tracks
        tracks = Track.order("RANDOM()").limit(11)
        render json: tracks, status: :ok
      end

      def like_track
        track = Track.find(params[:id])
        liked_playlist = Playlist.find_or_create_liked_playlist(current_user, track)

        unless liked_playlist.tracks.include?(track)
          liked_playlist.tracks << track
        end

        render json: { message: "Track liked successfully", playlist: liked_playlist }, status: :ok
      end


      private

      def format_track(track)
        {
          artistName: track.artist_name,
          id: track.id,
          name: track.name,
          releaseDate: track.release_date,
          kind: track.kind,
          artistId: track.artist_id,
          artistUrl: track.artist_url,
          contentAdvisoryRating: track.content_advisory_rating,
          artworkUrl100: track.artwork_url,
          genres: track.genres,
          url: track.cloud_url
        }
      end
    end
  end
end
