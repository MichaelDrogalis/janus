Feature: Verify the contract for a JSON service
  In order to drive a versioned, evolable API for a JSON service
  As a consuming developer
  I want to verify that the service meets a contract

  Scenario: Verify a single contract for my correct service
    Given I have a mock HTTP service
    And   a web service at "/service" that returns JSON:
    """
    {
      "id": 10,
      "features": ["a", "b"]
    }
    """
    And a contract "simple JSON service":
    """
    (service "simple JSON service"
      (contract "GET document"
        (method :get)
        (url "http://localhost:4568/service")
        (header "Content-Type" "application/json")

        (should-have :path "$.id" :of-type :number)
        (should-have :path "$..features[*]" :matching #"[a-z]")))
    """
    When I run janus with the contract "simple JSON service"
    Then the output from janus should contain:
    """
    1 service (0 failed)
    """
