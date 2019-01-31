require_relative '../spec_helper'

describe 'Artist' do
  before do
    @prince = Artist.create(name: "The Artist Formerly Known As Prince")
    @madonna = Artist.create(name: "Madonna")
  end

  after do
    clean_database
  end

  it 'has a name' do
    expect(Artist.find_by(name: "The Artist Formerly Known As Prince")).to eq(@prince)
  end

  it "has a slugified name" do
    expect(@prince.to_slug).to eq("the-artist-formerly-known-as-prince")
    expect(@madonna.to_slug).to eq("madonna")
  end

  it 'can build a song' do
    song = @prince.songs.build(name: "A Song By Prince")
    song.save

    expect(@prince.songs).to include(song)
  end

  it 'can create a song' do
    song = @prince.songs.create(name: "A Different Song By Prince")

    expect(@prince.songs).to include(song)
  end

  it 'knows about songs that are affiliated with it' do
    song = Song.create(name: "Bestest Song in the Worldz", artist: @prince)

    expect(@prince.songs).to include(song)
  end

  it 'can add many songs at the same time' do
    song_1 = Song.create(:name => "A Song By Prince")
    song_2 = Song.create(:name => "A Song By Prince 2")
    @prince.songs << [song_1, song_2]

    expect(Artist.find_by(name: "The Artist Formerly Known As Prince").songs.count).to eq(2)
  end

  it 'knows about its genres' do
    song = Song.create(name: "Super Hip Music")
    genre = Genre.create(name: "Soul")
    song.genre = genre
    song.save
    @prince.songs << song

    expect(@prince.genres).to include(genre)
  end
end
