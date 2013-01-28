require 'tempfile'

namespace :emailvision  do

  desc "Sync unsubscribed people with local database"

  task :create_export_unsubscribed_people => :environment do

    @@emvAPI ||= DriesS::Emailvision::Api.new(:endpoint => 'apiexport')
    @@emvAPI.open_connection

    return_object = @@emvAPI.get.createDownloadByMailinglist.call :mailinglistId => @@emvAPI.sync_segment_id, :operationType => "UNJOIN_MEMBERS", :fieldSelection => "EMAIL", :fileFormat => "CSV"

    File.open("#{Rails.root.to_s}/tmp/unsubscribed_people_list_id", "w+") do |f|
      f.write(return_object)
    end

    @@emvAPI.close_connection

  end

  task :sync_unsubscribed_people => :environment do

    abort unless File.exist?("#{Rails.root.to_s}/tmp/unsubscribed_people_list_id")

    export_list_id = File.read("#{Rails.root.to_s}/tmp/unsubscribed_people_list_id")

    @@emvAPI ||= DriesS::Emailvision::Api.new(:endpoint => 'apiexport')
    @@emvAPI.open_connection

    return_object = @@emvAPI.get.getDownloadFile.call :id => export_list_id

    if return_object["apiDownloadFile"]["fileStatus"] == "OK"
      members = return_object["apiDownloadFile"]["fileContent"].split( /\r?\n/ )
      members_to_update = User.where("email in (?)", members).where(User.emailvision_enabled_column.to_sym => true)
      User.where(["email in (?) and #{User.emailvision_enabled_column} = ?", members_to_update.map(&:email), true]).each do |user|
        user.update_attribute(User.emailvision_enabled_column.to_sym, false)
      end

      # delete tmp file

      File.delete("#{Rails.root.to_s}/tmp/unsubscribed_people_list_id")

    end
    @@emvAPI.close_connection
  end
end