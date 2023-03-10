require_relative '../lib/album_repository'


RSpec.describe AlbumRepository do 
    

        def reset_albums_table
            seed_sql = File.read('spec/seeds_albums.sql')
            connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
            connection.exec(seed_sql)
        end

        before(:each) do 
            reset_albums_table
        end
    
    it 'returns all ' do
        repo = AlbumRepository.new

        albums = repo.all

        expect(albums.length).to eq(2)
        expect(albums.first.id).to eq('1')
        expect(albums.first.title).to eq('Jungle')
        expect(albums.first.release_year).to eq('2016')
        expect(albums.first.artist_id).to eq('1')
    end

    it 'returns an artist with given id' do 
        repo = AlbumRepository.new

        albums = repo.find(1)
        expect(albums.title).to eq('Jungle')
        expect(albums.release_year).to eq('2016')
        expect(albums.artist_id).to eq('1')
    end

    it 'creates new album' do 
        repo = AlbumRepository.new

        album = Album.new
        album.title ='Synergy'
        album.release_year = '2015'
        album.artist_id = '3'

        repo.create(album)
        album = repo.all

        last_album = album.last
        expect(last_album.title).to eq('Synergy')
        expect(last_album.release_year).to eq('2015')
        expect(last_album.artist_id).to eq('3')   
    end 
    it 'deletes album with id 1' do 
        repo = AlbumRepository.new

        id_to_delete = 1
        repo.delete(id_to_delete)
       
        all_albums = repo.all
        expect(all_albums.length).to eq 1
        expect(all_albums.first.id).to eq('2')
    end

    it 'updates whole album ' do 
        repo = AlbumRepository.new
        album = repo.find(1)

        album.title = 'lala'
        album.release_year = '1999'
        album.artist_id = '5'

        repo.update(album)

        updated_album = repo.find(1)
        expect(updated_album.title).to eq('lala')
        expect(updated_album.release_year).to eq('1999')
        expect(updated_album.artist_id).to eq('5')
    end 

end