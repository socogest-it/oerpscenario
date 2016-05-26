# -*- coding: utf-8 -*-
@upgrade_from_9.0.5
Feature: upgrade to 9.0.6

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | product_dimension                             |
      | account_operation_rule_early_payment_discount |
    Then my modules should have been installed and models reloaded
    Then I set the version of the instance to "9.0.6"

  @payment_term
  Scenario: update payment term
     Given I execute the SQL commands
       """;
         delete from account_payment_term_line;
       """

    Given "account.payment.term" is imported from CSV "setup/payment_term.csv" using delimiter ","

  Scenario: create account operation rule
    Given I need a "account.account" with oid: scenario.account_4090
    And having:
      | key             | value                                      |
      | name            | Skonti                                     |
      | code            | 4090                                       |
      | user_type_id    | by oid: account.data_account_type_expenses |
      | internal_type   | other                                      |

    Given I need a "account.operation.template" with oid: scenario.account_operation_template_skonto
    And having:
      | key          | value                                   |
      | name         | Skonto                                  |
      | label        | Skonto                                  |
      | company_id   | by oid: base.main_company               |
      | account_id   | by oid: scenario.account_4090           |
      | journal_id   | by oid: scenario.journal_ZKB1           |
      | amount_type  | percentage                              |
      | amount       | 100                                     |
      | tax_id       | by name: TVA due à 8.0% (Incl. TN)      |

    Given I need a "account.operation.rule" with oid: scenario.account_operation_rule_skonto
    And having:
      | key          | value                                              |
      | name         | Skonto                                             |
      | rule_type    | early_payment_discount                             |
      | operations   | by oid: scenario.account_operation_template_skonto |
