Cypress.Commands.add("register_user", (username, email) => {
  cy.visit('/register')
      .get('input[name="username"]').type(username)
      .get('input[name="email"]').type(email)
      .get('input[name="password"]').type('test')
      .get('input[type="submit"]').click();
});

Cypress.Commands.add("login_user", (email) => {
  cy.get('a').contains('Log In').click()
      .get('input[name="email"]').type(email)
      .get('input[name="password"]').type('test')
      .get('input[type="submit"]').click()
});

Cypress.Commands.add("logout_user", () => {
  cy.get('.navbar-burger').click();
  cy.contains('Log Out').click();
});
