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
  if file.split('.').last != 'V3'
    return '文件类型只能为只能为音频文件！！！'
  end
  if File::exist?(target)
    f = File.open(target)
    File.delete(f)
    puts 'file deleted'
  end
  File.open(file, 'wb') do |f|
    f.write tempfile.read
    `ffmpeg -i #{file} #{target}`
  end

  begin
    f = File.open(target)
    send_file(f, filename: mp3_filename)
  ensure
    f.close
  end

end
