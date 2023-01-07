require_relative '../app'

RSpec.describe Application do 
    def reset_albums_table
        seed_sql = File.read('spec/seeds_albums.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
        connection.exec(seed_sql)
      end
    
      def reset_artists_table
        seed_sql = File.read('spec/seeds_artists.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
        connection.exec(seed_sql)
      end
    
      before(:each) do
        reset_albums_table
        reset_artists_table
      end
        it 'gets user input ' do 
            io = double :io
            album_repository = AlbumRepository.new
            artist_repository = ArtistRepository.new
            application = Application.new('music_library_test', io, album_repository, artist_repository)
            expect(io).to receive(:puts).with('Welcome to the music library manager!')
            expect(io).to receive(:puts).with('What would you like to do?')
            expect(io).to receive(:puts).with('1 - List all albums')
            expect(io).to receive(:puts).with('2 - List all artists')
            expect(io).to receive(:puts).with('Enter your choice:')
            expect(io).to receive(:gets).and_return('1')
            expect(io).to receive(:puts).with('Here is the list of albums:')
            
            application.run
        end
    
end  