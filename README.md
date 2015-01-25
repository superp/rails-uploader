# HTML5 File uploader for rails

This gem use https://github.com/blueimp/jQuery-File-Upload for upload files.

Preview:

![Uploader in use](http://img39.imageshack.us/img39/2206/railsuploader.png)

## Install

In Gemfile:

```
gem "rails-uploader"
```

In routes:

``` ruby
mount Uploader::Engine => '/uploader'
```

Migration for ActiveRecord:

```bash
$> rake uploader:install:migrations
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

  # structure of returned json array of files. (used in Hash.to_json operation)
  def serializable_hash(options=nil)
    {
        "id" => id.to_s,
        "filename" => File.basename(data.path),
        "url" => data.url,
        "thumb_url" => data.url(:thumb),
        "public_token" => public_token
    }
  end
end
```

For example user has one picture:

``` ruby
class User < ActiveRecord::Base
  has_one :picture, :as => :assetable, :dependent => :destroy

  fileuploads :picture

  # If your don't use strong_parameters, uncomment next line
  # attr_accessible :fileupload_guid
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

### Notice

User method fileuploads only once pre model. So if you have many attached files, use this:

``` ruby
class User
  include Uploader::Fileuploads

  has_one :picture, :as => :assetable
  has_one :avatar, :as => :assetable

  fileuploads :picture, :avatar
end
```


### Include assets

Javascripts:

```
//= require uploader/application
```

Stylesheets:

```
*= require uploader/application
```

### Views

```erb
<%= uploader_field_tag :article, :photo %>
```

or FormBuilder:

```erb
<%= form.uploader_field :photo, :sortable => true %>
```

### Formtastic

```erb
<%= f.input :pictures, :as => :uploader %>
```

### SimpleForm

```erb
<%= f.input :pictures, :as => :uploader, :input_html => {:sortable => true} %>
```

#### Confirming deletions

This is only working in Formtastic and FormBuilder:

``` erb
# formtastic
<%= f.input :picture, :as => :uploader, :confirm_delete => true %>
# the i18n lookup key would be en.formtastic.delete_confirmations.picture
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2013 Fodojo, released under the MIT license
