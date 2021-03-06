Feature: Web Search
  In order to get search results
  As a API user
  I want to query yahoo boss

  @inprogress
  Scenario Outline: Search
    Given a valid API key
    When I do the following search
      | type   | term   | count   | limit   |
      | <type> | <term> | <count> | <limit> |
    Then I will receive "<result_count>" search results
    And I will be able to see the total hits
  
  Examples: all search types
    | type    | term        | count | limit | result_count |
    | web     | monkey      | 1     | 1     | 1            |
    | images  | monkey      | 1     | 1     | 1            |
    | news    | monkey      | 1     | 1     | 1            |
    | spell   | girafe      | 1     | 1     | 1            |
    | inlinks | hotmail.com | 1     | 1     | 1            |

  Examples: complex cases for searching the web
    | type | term   | count | limit | result_count |
    | web  | monkey |       | 5     | 5            |
    | web  | monkey | 1     | 3     | 3            |
    | web  | monkey | 5     | 6     | 10           |
    | web  | monkey | 50    | 100   | 100          |
