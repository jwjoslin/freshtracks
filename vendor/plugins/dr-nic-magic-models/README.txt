See http://magicmodels.rubyforge.org/dr_nic_magic_models for pretty README

Ugly README (from website/index.txt in Textile format):
h1. Dr Nic's Magic Models

If you've used Ruby on Rails you'll have written at least one model class like this:

<pre syntax='ruby'>
class Person < ActiveRecord::Base
  has_many :memberships
  has_many :groups, :through => :memberships
  belongs_to :family
  validates_presence_of :firstname, :lastname, :email
end
</pre>

A few minutes later you'll have wondered to yourself,

<blockquote>
Why do I have write my own <code>has_many</code>, <code>belongs_to</code>, and <code>validates_presence_of</code> 
commands if all the data is in the database schema?
</blockquote>

Now, for the very first time, your classes can look like this:

<pre syntax='ruby'>
class Person < ActiveRecord::Base
end
</pre>

or, if you are lazy...

<pre syntax='ruby'>
class Person < ActiveRecord::Base; end
</pre>

or, if you read right to the end of this page, this...

<pre syntax='ruby'>
# Go fish.
</pre>

Magic and mystery abound. All for you. Impress your friends, amaze your mother.

NOTE: The gratuitous use of *Dr Nic's* in the name should only enhance the mystical magikery,
for magic needs a magician; and I love magic. I always wanted to create my own magic trick.
So I shall be the magician for the sake of magic itself. I look a bit like Harry Potter too,
if Harry were 32 and better dressed.

h2. Installation

To install the Dr Nic's Magic Models gem you can run the following command to 
fetch the gem remotely from RubyForge:
<pre>
gem install dr_nic_magic_models
</pre>

or "download the gem manually":http://rubyforge.org/projects/magicmodels and 
run the above command in the download directory.

Now you need to <code>require</code> the gem into your Ruby/Rails app. Insert the following
line into your script (use <code>config/environment.rb</code> for your Rails apps):

<pre>
require 'dr_nic_magic_models'
</pre>

Your application is now blessed with magical mystery.

h2. David Copperfield eat your Ruby-crusted heart out

Let's demonstrate the magical mystery in all its full-stage glory. Create a Ruby on Rails app (example uses sqlite3, but use your favourite databas):

<pre syntax="ruby">
rails magic_show -d sqlite3
cd magic_show
ruby script/generate model Person
ruby script/generate model Group
ruby script/generate model Membership
</pre>

Update the migration <code>001_create_people.rb</code> with:
<pre syntax="ruby">
class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :firstname, :string, :null => false
      t.column :lastname, :string, :null => false
      t.column :email, :string, :null => false
    end
  end

  def self.down
    drop_table :people
  end
end
</pre>

Similarly, update the <code>def self.up</code> method of <code>002_create_groups.rb</code>
with:
<pre syntax="ruby">
    create_table :groups do |t|
      t.column :name, :string, :null => false
      t.column :description, :string
    end
</pre>

and <code>003_create_memberships.rb</code> with:
<pre syntax="ruby">
    create_table :memberships do |t|
      t.column :person_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
</pre>

And run your migrations to create the three tables:
<pre>
rake db:migrate
</pre>

h3. And now for some "woofle dust":http://en.wikipedia.org/wiki/List_of_conjuring_terms ...

At the end of <code>config/environment.rb</code> add the following line:

<pre>
require 'dr_nic_magic_models'
</pre>

Now, let's do a magic trick. First, let's check our model classes (<code>app/models/person.rb</code> etc):

<pre syntax="ruby">
class Person < ActiveRecord::Base
end
class Group < ActiveRecord::Base
end
class Membership < ActiveRecord::Base
end
</pre>

Nothing suspicious here. We have no validations and no associations. Just some plain old model classes.

UPDATE: To turn on magic validations, you now need to invoke <code>generate_validations</code> on defined classes. So, update your model classes:

<pre syntax="ruby">
class Person < ActiveRecord::Base
  generate_validations
end
class Group < ActiveRecord::Base
  generate_validations
end
class Membership < ActiveRecord::Base
  generate_validations
end
</pre>

For this trick, we'll need an ordinary console session. Any old one lying around the house will do.

<pre>
ruby script/console
</pre>

Now a normal model class is valid until you explicitly add <code>validates_xxx</code> commands.
With Dr Nic's Magic Models:

<pre syntax="ruby">
person = Person.new
=> #<Person:0x393e0f8 @attributes={"lastname"=>"", "firstname"=>"", "email"=>""}, @new_record=true>
person.valid?
=> false
person.errors
=> #<ActiveRecord::Errors:0x3537b38 @errors={
	"firstname"=>["can't be blank", "is too long (maximum is 255 characters)"], 
	"lastname"=>["can't be blank", "is too long (maximum is 255 characters)"], 
	"email"=>["can't be blank", "is too long (maximum is 255 characters)"]},
	 @base=#<Person:0x3538bf0 @errors=#<ActiveRecord::Errors:0x3537b38 ...>, @new_record=true, 
		@attributes={"lastname"=>nil, "firstname"=>nil, "email"=>nil}>>
</pre>

*Kapoow!* Instant validation! (NOTE: not as instant as it used to be - remember - you need to call <code>generate_validations</code> on each class as required)

Because you specified the three columns as <code>:null => false</code>,
your ActiveRecord models will now automagically generated <code>validates_presence_of</code> 
for each non-null field, plus several other validations (since version 0.8.0).

Ok, we're just warming up.

Your models normally require association commands (<code>has_many</code>, <code>belongs_to</code>, etc, as 
demonstrated above) to have the brilliantly simple support that Rails/ActiveRecords are known for.

Let's just watch what Dr Nic's Magic Models can do without any effort at all...

<pre syntax="ruby">
person = Person.create(:firstname => "Nic", :lastname => "Williams", :email => "drnicwilliams@gmail.com")
group = Group.create(:name => "Magic Models Forum", :description => "http://groups.google.com/magicmodels")
membership = Membership.create(:person => person, :group => group)
person.memberships.length
=> 1
membership.person
=> <Person:0x38898e8 @attributes={"lastname"=>"Williams", "firstname"=>"Nic", 
"id"=>"1", "email"=>"drnicwilliams@gmail.com"}>
group.memberships
=> [<Membership:0x3c8cd70 @attributes={"group_id"=>"1", "id"=>"1", "person_id"=>"1"}>]
</pre>


The final association trick is a ripper. Automatic generation of <code>has_many :through</code> associations...

<pre syntax="ruby">
>> person.groups
=> [<Group:0x39047e0 @attributes={"name"=>"Magic Models Forum", "id"=>"1", "description"=>nil}>]
>> group.people
=> [<Person:0x3c33580 @attributes={"lastname"=>"Williams", "firstname"=>"Nic", 
"id"=>"1", "email"=>"drnicwilliams@gmail.com"}>]
</pre>

h3. Drum roll...

Ladies and gentlemen. For my final feat of magical mastery, I'll ask you to do
something you've never done before. This illusion is akin to the "floating lady":http://www.toytent.com/Posters/985.html
illusion that has been passed down through generations of magicians.

Exit your console session.

DELETE your three model classes: <code>person.rb, group.rb, and membership.rb</code> from the 
<code>app/models</code> folder. (You can always get them back via the model generator... be fearless!)

<pre>rm app/models/*.rb</pre>

Re-launch your console.

*drums are still rolling...*

Be prepared to applaud loudly...

<pre syntax="ruby">
>> Person
=> Person
</pre>

You applaud loudly, but watch for more...

<pre syntax="ruby">
>> Person.new.valid?
=> false
>> person = Person.find(1)
=> <Person:0x3958930 @attributes={"lastname"=>"Williams", "firstname"=>"Nic", 
"id"=>"1", "email"=>"drnicwilliams@gmail.com"}>
>> person.valid?
=> true
>> person.memberships
=> [<Membership:0x393a000 @attributes={"group_id"=>"1", "id"=>"1", "person_id"=>"1"}>]
>> person.groups
=> [<Group:0x390df60 @attributes={"name"=>"Magic Models Forum", "id"=>"1", "description"=>nil}>]
</pre>

h3. Tada!

The end.

h3. Use modules to scope your magic

Only want to pick up tables starting with <code>blog_</code>?

<pre syntax="ruby">module Blog
  magic_module :table_name_prefix => 'blog_'
end

Blog::Post.table_name #	=> 'blog_posts'
</pre>

h2. Dr Nic's Blog

"http://www.drnicwilliams.com":http://www.drnicwilliams.com - for future announcements and
other stories and things.

h2. Articles about Magic Models

* "Announcement":http://drnicwilliams.com/2006/08/07/ann-dr-nics-magic-models/
* "BTS - Class creation":http://drnicwilliams.com/2006/08/10/bts-magic-models-class-creation/


h2. Forum

"http://groups.google.com/group/magicmodels":http://groups.google.com/group/magicmodels

h2. Licence

This code is free to use under the terms of the MIT licence. 

h2. Contact

Comments are welcome. Send an email to "Dr Nic Williams":mailto:drnicwilliams@gmail.com
or via his blog at "http://www.drnicwilliams.com":http://www.drnicwilliams.com

