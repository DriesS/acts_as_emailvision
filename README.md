# Acts As Emailvision

This gem is inspired by the [mailchimp_fu](https://github.com/roomorama/mailchimp_fu) gem by [Roomorama](https://github.com/roomorama) and is based on the emailvision Member api wrapper made by [basgys](https://github.com/basgys/emailvision). 

The gem easily integrates a model with the Member Api of emailvision for marketing newsletters.

## Issue Tracker
Please submit any bugs, errors or annoyances on our Github issues at:

https://github.com/DriesS/acts_as_emailvision/issues

## Documentation

This page has documentation on the following:

* Installation
* Usage
* Examples

### Installation
The gem is for the moment only usable with Rails 3, to install the gem add this to your Gemfile :

    gem "acts_as_emailvision",

#### Prerequisites

For this gem you will need to have an account set up at [EmailVision](http://www.emailvision.com).

Acts_as_emailvision expects a model with the following required fields:

`` email:string `` The email address to add/remove from a emailvision list.  
`` wants_email:boolean `` A boolean that decide if the user wants to receive newsletters or not.

Additionally, the gem allows you to insert every possible field that you have in your database and also in the members table at emailvision

#### After Installation

Run the generator to generate the emailvision config file : 

    rails g acts_as_emailvision_config

Once the config file is generated you will find the file in config/emailvision.yml. Here you need to fill in the correct information to use the api. This information you can find in the campaignCommander interface. If not, contact the emailvision support.

### Usage

The following example assumes that you have a model named ‘User’, which has the required `` email `` and `` wants_email `` fields.

Add this after opening the class User  :

    acts_as_emailvision_subscriber({:enabled => :wants_email})

Adding this will automatically subscribe people with their email to emailvision if the `` wants_email `` field is set to true. If the field `` wants_email `` is changed to false, the user will be unsubscribed.

#### Customizing

You can customize the different fields that are used by the acts_as_emailvision_subscriber. For example, assume that your field for `` email ``  = mail_address and for `` wants_email `` = receive_newsletter you can call the acts_as_emailvision_subscriber like this : 

    acts_as_emailvision_subscriber({:enabled => :receive_newsletter, :email => :mail_address})

If you want to push more fields to emailvision, for example `` last_name `` and `` first_name `` you have to call the method acts_as_emailvision_subscriber like :

    acts_as_emailvision_subscriber({:enabled => :wants_email}) do
      lastname   :last_name
      firstname  :first_name
    end

Where ``lastname`` is the field at the members table in emailvision and ``:last_name`` is the field in your database. Whenever one of these fields is updated, they will be send to emailvision to update the entry at their database.

#### Methods && Callbacks

Once added to a model, acts_as_emailvision_subscriber adds the following methods && callbacks to model instances:

* ``subscribe_or_update_emailvision`` running after create and before update, update if records already exists at emailvision otherwise he will create it.
* ``unsubscribe_emailvision`` running on before update
* ``resubscribe_emailvision`` called by other methods if user needs to be (re)subscribed and is already on emailvision
* ``exists_on_emailvision?``


### Examples

The creation of an user and updates are automticly send to emailvision because of the callbacks.

If you want to subscribe people manually you can run the methods as following :

``@user.subscribe_or_update_emailvision ``  
``@user. unsubscribe_emailvision``  
``@user.exists_on_emailvision? # returns true or false``  


## Todo

* Writing more tests
* Check if gem runs fine under Ruby > 1.9.2
* Writing rake task to do a sync between your database <-> emailvision


## Contributing to acts_as_emailvision
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Dries Steenhouwer. See LICENSE.txt for
further details.

