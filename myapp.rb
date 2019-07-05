require 'sinatra'

get '/' do
  erb :index
end

post '/upload' do
  unless params[:file] &&
      (tempfile = params[:file][:tempfile]) &&
      (filename = params[:file][:filename])
    @error = 'No file selected'
    redirect to('/upload')
  end
  file = "files/#{filename}"
  mp3_filename = filename.split('.').first + '.mp3'
  target = "files/#{mp3_filename}"
  File.open(file, 'wb') do |f|
    f.write tempfile.read
    `ffmpeg -i #{file} #{target}`
  end

  begin
    f = File.open(target)
    send_file(f, filename: mp3_filename)
  ensure
    f.close
    File.delete(f)
  end

end
