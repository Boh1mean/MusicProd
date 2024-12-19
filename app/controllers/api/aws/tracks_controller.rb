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
        tracks = Track.where(kind: "track").order(created_at: :desc).limit(10)

        formatted_tracks = tracks.map do |track|
          {
            artistName: track.artist_name,
            id: track.id.to_s,
            name: track.name,
            releaseDate: track.release_date || "",
            kind: track.kind,
            artistId: track.artist_id || "",
            artistUrl: track.artist_url || "",
            contentAdvisoryRating: track.content_advisory_rating || "",
            artworkUrl100: track.artwork_url,
            genres: track.genres.map { |genre| { genreId: "", name: genre, url: "" } },
            url: track.cloud_url
          }
        end

        response = {
          feed: {
            title: "Top Songs",
            id: request.original_url,
            author: {
              name: "Your Service Name",
              url: "https://your-service-url.com/"
            },
            links: [
              {
                self: request.original_url
              }
            ],
            copyright: "Copyright © 2024 Your Service Name. All rights reserved.",
            country: "us",
            icon: "https://your-service-url.com/favicon.ico",
            updated: Time.now.strftime("%a, %d %b %Y %H:%M:%S %z"),
            results: formatted_tracks
          }
        }
        render json: response, status: :ok
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
          kind: track.kind,
          artworkUrl100: track.artwork_url,
          urlCloud: track.cloud_url
        }
      end
    end
  end
end
