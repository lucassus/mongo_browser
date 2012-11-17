Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "mongo_browser"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      | --version      |
      | --mongodb-host |
      | --mongodb-port |
      | --log-level    |
    And the banner should document that this app takes no arguments

  Scenario: Run the app for the given mongodb host and port
    When I run `mongo_browser --mongodb-host thehost --mongodb-port 666`
    Then the output should contain:
      """
      Running on the master node thehost:666
      """
