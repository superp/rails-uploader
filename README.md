# HTML5 File uploader for rails

This gem use https://github.com/blueimp/jQuery-File-Upload for upload files.

Preview:

![Uploader in use](http://img39.imageshack.us/img39/2206/railsuploader.png)

## Install

In Gemfile:

  gem "rails-uploader"

In routes:  

``` ruby
mount Uploader::Engine => '/uploader'
```

## Usage

Architecture to store uploaded files (cancan integration):

``` ruby
class Asset < ActiveRecord::Base
  include Uploader::Asset
  
  def uploader_create(params, request = nil)
    ability = Ability.new(request.env['warden'].user)
    
    if ability.can? :create, self
      self.user = request.env['warden'].user
      super
    else
      errors.add(:id, :access_denied)
    end
  end
  
  def uploader_destroy(params, request = nil)
    ability = Ability.new(request.env['warden'].user)
    
    if ability.can? :delete, self
      super
    else
      errors.add(:id, :access_denied)
    end
  end
end

class Picture < Asset
  mount_uploader :data, PictureUploader
  
  validates_integrity_of :data
  validates_filesize_of :data, :maximum => 2.megabytes.to_i
end
```

For example user has one picture:

``` ruby
class User < ActiveRecord::Base
  has_one :picture, :as => :assetable, :dependent => :destroy
  
  fileuploads :picture
end
```

Find asset by foreign key or guid:

``` ruby
@user.fileupload_asset(:picture)
```

### Mongoid

No parent asset model is required, one only has to `include Uploader::Asset::Mongoid` into the
model that should act like an asset:

``` ruby
class Picture
  include Mongoid::Document
  include Uploader::Asset::Mongoid

  belongs_to :user
end

class User
  include Mongoid::Document
  include Uploader::Fileuploads

  has_one :picture, :as => :assetable

  fileuploads :picture
end
```

### Include assets

Javascripts:

``` ruby
//= require uploader/application
```

Stylesheets:

``` ruby
*= require uploader/application  
```

### Views

``` ruby
<%= uploader_field_tag :article, :photo %>
```

or FormBuilder:

``` ruby
<%= form.uploader_field :photo %>
```

### Formtastic

``` ruby
<%= f.input :picture, :as => :uploader %>
```

### SimpleForm

``` ruby
<%= f.input :picture, :as => :uploader %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2012 Aimbulance, released under the MIT license
