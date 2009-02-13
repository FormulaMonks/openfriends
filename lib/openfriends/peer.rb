module OpenFriends

  # Any site that supports OpenFriends as a provider, consumer, or both
  # is represented as a +Peer+.
  #
  # While the +Peer+ class can be used directly, it is recommended
  # you use the +Consumer+ and +Provider+ classes (which are aliases
  # for +Peer+) for clarity in your code.
  #
  # == OpenFriends Descriptors (OFD) - JSON
  #
  # A Peer has a descriptor in the OFD format, which is encoded in JSON
  # as follows
  #
  # OFD Keys:
  # * name - the name of the web site/service
  # * url - for a Consumer, this is the url to send (POST) contacts to
  #         for a Provider, this is the url needed to ask for (GET) contacts
  #         from
  # * token - a unique identifier for the user sending/receiving contacts
  #           this is used to ensure providers and consumers are referring
  #           to the same user
  #
  # *NOTE*: since the token uniquely identifies a user, you _have_ to
  # instantiate a new +Peer+ for each user.
  #
  # ==== Sample OFD
  # {"name": "Swordfsh", "url": "\http://getopenfriends.com", "token": "bawiefiabwfwali}
  #
  # == OpenFriends Contacts (OFC) - JSON
  #
  # Peers send that descriptor along with a list of contacts in the 
  # OFC format, which is encoded in JSON as follows
  #
  # OFC Keys:
  # * name - username of contact
  # * email - array of emails for the contact. zero-length is allowed -- it is up to the
  # 
  # * accounts - a hash of the accounts known about this user
  #
  # Sample OFC
  # {"name": "Foobie Barius", "email": "foobie@example.com", "accounts": {"flickr.com": "myflickraccountname", "twitter.com": "mytwitterusername"}
  #
  # == OpenFriends Export (OFX) - POST
  #
  # OFX POST parameters:
  # * provider - a JSON string containing the OFD of the Provider (origin of the POST)
  # * consumer - a JSON string containing the OFD of the Consumer (destination of the POST)
  # * contacts - a JSON array of contacts in the OFC format
  #

  class Peer
    attr :attributes

    # New peers must be instantiated with a descriptor.
    #
    # Arguments:
    # * +descriptor+ - a JSON string conforming to the OpenFriends Descriptor (OFD) format.
    # * +options+ - hash of additional options.
    def initialize(descriptor, options = {})
      @attributes = JSON.parse(descriptor).merge(options)
    end

    def name #:nodoc:
      attributes['name']
    end

    def url #:nodoc:
      attributes['url']
    end

    def token #:nodoc:
      attributes['token']
    end

    # Returns the OFD for this instance.
    def descriptor
      attributes.to_json
    end

    # POSTS a list of contacts to another Peer according to the OFX specification
    #
    # Returns a +Response+ object
    #
    # Arguments:
    # * +contacts+ - a JSON string conforming to the OpenFriends Contact (OFC) format.
    # * +options+ - hash of additional options.
    #
    # Required +options+:
    # * +:to+ - a +Consumer+ instance to send contacts to.
    #
    def send(contacts, options = {})
      raise "Undefined consumer" unless options[:to]

      consumer = options[:to]

      http_response = http_post(URI.parse(consumer.url),
        'provider' => descriptor,
        'consumer' => consumer.descriptor,
        'contacts' => contacts)

      Response.new(self, http_response)
    end

  private

    def http_post *params #:nodoc:
      Timeout.timeout(7) { Net::HTTP.post_form(*params) }
    rescue Exception
    end
  end
end
