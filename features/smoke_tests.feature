@smoke_tests
Feature: Smoke tests
  Smoke testing scenarios to make sure all system components are up and running.

  Scenario: Services should be up and listening to their assigned port
    * services should be listening on ports:
      | 80    | apache     |
      | 8081  | tomcat     |
      | 5432  | postgresql |

  Scenario: Appfuse is up and listening on port 80
    Given I am at the "/login" page
    Then I should see the text "Sign In"
