require 'fileutils'

class SiteGenerator
  attr_accessor :rendered_path

  def initialize(path)
    self.rendered_path = path
    FileUtils::mkdir_p self.rendered_path
    FileUtils::mkdir_p "#{self.rendered_path}/songs"
    FileUtils::mkdir_p "#{self.rendered_path}/artists"
    FileUtils::mkdir_p "#{self.rendered_path}/genres"
  end

  def generate
    build_index
    build_artists_index
    build_artist_page
    build_songs_index
    build_song_page
    build_genres_index
    build_genre_page
  end

  def build_artist_page
    # read erb / setup html
    # for each artist, render a show page named after the artist
    Artist.all.each do |artist| # kanye
      render_template('artists/show.html', "artists/#{artist.to_slug}.html") do
        @artist = artist
      end
    end
  end

  def build_song_page
    # read erb / setup html
    # for each artist, render a show page named after the artist
    Song.all.each do |song| # kanye
      render_template('songs/show.html', "songs/#{song.to_slug}.html") do
        @song = song
      end
    end
  end

  def build_genre_page
    # read erb / setup html
    # for each genre, render a show page named after the genre
    Genre.all.each do |genre| # kanye
      render_template('genres/show.html', "genres/#{genre.to_slug}.html") do
        @genre = genre
      end
    end
  end

  # This is a pretty meta method. It's basically
  # a rendering helper. You could hardcode lots
  # of this logic into the individual build_ methods
  def render_template(template, filename = template)
    html = File.read("./app/views/#{template}.erb")
    doc = ERB.new(html)

    yield if block_given?

    File.open("#{@rendered_path}/#{filename}", "w+") do |f|
      f << doc.result(binding)
    end
  end

  def build_index
    render_template("index.html")
  end

  def build_artists_index
    render_template 'artists/index.html' do
      @artists = Artist.all
    end
  end

  def build_songs_index
    render_template 'songs/index.html' do
      @songs = Song.all
    end
  end

  def build_genres_index
    render_template 'genres/index.html' do
      @genres = Genre.all
    end
  end

end
