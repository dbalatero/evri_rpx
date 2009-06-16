evri_rpx
========
The `evri_rpx` library provides an wrapper around RPXNow's universal sign-on API.

Features
--------
 - Clean and simple API design
 - Full SSL certificate validation
 - Implements all RPX API calls, including ones available at the Pro level
 - 100% spec coverage
 - Clear documentation (and if not, let me know!)

TODO
----
 - Rails helper methods for building up the iframe/popup widget code.

Usage/Install
-------------
 - Grab an API key/account from http://rpxnow.com
 - As gem: `sudo gem install dbalatero-evri_rpx -s http://gems.github.com`
 - The gem will be on RubyForge soon, but their project request page is messed up, so no dice for now.

Examples
========

Here are examples of the features in `evri_rpx`. As well, you can browse the RDocs here: [http://rdoc.info/projects/dbalatero/evri_rpx](http://rdoc.info/projects/dbalatero/evri_rpx)

All interaction with the API goes through the public methods in `Evri::RPX::Session`, which often return complex objects. See [RDocs](http://rdoc.info/projects/dbalatero/evri_rpx) for all the methods available on these objects.

To see examples of raw JSON responses from RPX, see [http://github.com/dbalatero/evri_rpx/tree/master/spec/fixtures](http://github.com/dbalatero/evri_rpx/tree/master/spec/fixtures)

Validating tokens in your Rails app
-----------------------------------
    class RPXController < ApplicationController
      def process_token
        if params[:token].blank?
          flash[:notice] = 'You cancelled RPX login.'
          redirect_to root_url
          return
        end

        # Returns a User object.
        @user = rpx.auth_info(params[:token])

        # rest of your logic here
      end

      private
      def rpx
        @rpx ||= Evri::RPX::Session.new('myapikey')
      end
    end

Mapping your local user's primary keys to third-party providers
---------------------------------------------------------
    class RPXController < ApplicationController
      def process_token
        # Returns a User object.
        @user = rpx.auth_info(params[:token])

        # Get the corresponding user out of the database for a 
        # given email.
        @user_in_mysql = User.find_by_email(@user.email)

        # Map this user's local primary key to the 3rd-party provider
        rpx.map(@user, @user_in_mysql.id)
      end

      private
      def rpx
        @rpx ||= Evri::RPX::Session.new('myapikey')
      end
    end

Authenticating already mapped users
-----------------------------------
    class RPXController < ApplicationController
      def process_token
        # Returns a User object.
        @rpx_user = rpx.auth_info(params[:token])

        @user = User.find(:first, :conditions => ['id = ?', @rpx_user.identifier])
        if @user
          # log them in
          self.current_user = @user
        end
      end

      private
      def rpx
        @rpx ||= Evri::RPX::Session.new('myapikey')
      end
    end

Retrieving mappings for a given user's primary key
--------------------------------------------------
    user = User.find_by_email('foo@bar.com')
    rpx = Evri::RPX::Session.new('myapikey')
    mappings = rpx.mappings(user.id)

Retrieving all mappings for your application
--------------------------------------------
    rpx = Evri::RPX::Session.new('myapikey')
    all_mappings = rpx.all_mappings

    all_mappings.each do |identifier, mappings|
      puts "#{identifier} has the following mappings: " <<
           mappings.join(', ')
    end

Unmapping a user's primary key and 3rd-party identifier
-------------------------------------------------------
    user = User.find(50)

    rpx = Evri::RPX::Session.new('myapikey')
    rpx.unmap('http://brian.myopenid.com/', user.id)

Retrieving contact lists for users (requires RPX Pro)
-----------------------------------------------------
    rpx = Evri::RPX::Session.new('myapikey')

    # Without a User object, requires primary key.
    user = User.find(50)
    contact_list = rpx.get_contacts(user.id)

    # With a user object that is mapped already
    user = rpx.auth_info(params[:token])
    contact_list = rpx.get_contacts(user)

provider? methods for Users
------------------------------------
    user = rpx.auth_info(params[:token])

    if user.twitter?
      # post an article to twitter via the API
    elsif user.facebook?
      # post an article to facebook via FB connect
    end

Copyright
=========
Copyright (c) 2009 David Balatero, Evri, Inc. <dbalatero at evri dot com>. See LICENSE for details.
