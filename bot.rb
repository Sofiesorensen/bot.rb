require 'sinatra'
require 'json'
require 'sqlite3'

set :port, 5000

before do
  @params = JSON.parse(request.body.read)
end

post '/apply' do
  content_type :json
  puts @params

  botanswer = ''

  if @params['action']['slug'] == 'application'
    botanswer = 'You can apply here. Please make a description of your profile. Start with "I am (name)"'
    puts 'i am in'

    if @params['jobrole']['raw'] == 'pilot'
      botanswer = 'We are sorry, we have enough pilots'
    end
  end

  begin

    db = SQLite3::Database.open "jobbase.db"

    stm = db.prepare "SELECT job_opening FROM jobrole WHERE jobtitle='pilot'"
    rs = stm.execute

    rs.each do |row|
      puts row.join "\s"
    end

  rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

  ensure
    stm.close if stm
    db.close if db
  end

 {
      replies: [{type: 'text', content: botanswer}],
      conversation: {
          memory: {
              key: 'value'
          }
      }
  }.to_json

end

post '/description' do
  content_type :json
  puts @params

  botanswer = ''

  if @params['recive']['slug'] == 'description'
    botanswer = 'Thank you'
    puts 'i am in'

  end

  {
      replies: [{type: 'text', content: botanswer}],
      conversation: {
          memory: {
              key: 'value'
          }
      }
  }.to_json
  end
post '/errors' do
  puts @params

  200
end
