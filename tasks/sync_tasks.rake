namespace :emailvision  do
  desc "Sync unsubscribed people with local database"
  
  task :sync_unsubscribed_people => :environment do

    date = ENV['date'] || Date.today
    
    body = {
      :synchro_member => {
        :memberUID => "DATEUNJOIN:#{DriesS::Emailvision::Tools.date_format_unsubscribe(date)}"
      }
    }

    @@emvAPI ||= DriesS::Emailvision::Api.new
    @@emvAPI.open_connection
    
    return_object = @@emvAPI.post.member.getMembers(:body => body).call

    members = return_object["members"]["member"] if return_object["members"]

    email_addresses = Array.new

    if members
      if members.is_a?(Array)
        members.each do |member|
          email_addresses << member["attributes"]["entry"].find {|h|h["key"]=='EMAIL'}['value']
        end
      else
        email_addresses << members["attributes"]["entry"].find {|h|h["key"]=='EMAIL'}['value']
      end
    end

    User.where(["email in (?) and #{User.emailvision_enabled_column} = ?", email_addresses, true]).each do |user|
      user.update_attribute(User.emailvision_enabled_column.to_sym, false)
    end

  end
end