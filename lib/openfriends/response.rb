module OpenFriends

  # simple wrapper class to represent a HTTP response from
  # a +Consumer+ after a +send()+ from a Peer
  class Response
    attr :http
    attr :peer
    attr :code
    attr :url

    def initialize(peer, http_response) #:nodoc:
      @peer = peer
      @http = http_response
      @code = http ? http.code.to_i : 500
      @url  = redirect_url || peer.url
    end

    # determines the url for a +Consumer+ to redirect to after
    # receiving contacts
    #
    # The +Provider+ must inform the result of the operation to the user,
    # allowing him to stay in +Provider+ or redirect to +Consumer+
    # if the operation ended with an http 302 code.
    def redirect_url
      return unless redirect?
      return unless locations = http.to_hash["location"]

      url = locations.first
      url unless url.empty?
    end

    def success? #:nodoc:
      (200...300).include?(code)
    end

    def redirect? #:nodoc:
      (300...400).include?(code)
    end

    def client_error? #:nodoc:
      (400...500).include?(code)
    end

    def server_error? #:nodoc:
      (500...600).include?(code)
    end
  end
end
