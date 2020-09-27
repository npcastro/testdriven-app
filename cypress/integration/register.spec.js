const randomstring = require('randomstring');

const username = randomstring.generate();
const email = `${username}@test.com`;

describe('Register', () => {
  it('hould display the registration form', () => {
    cy.visit('/register')
      .get('h1').contains('Register')
      .get('form');
  });

  it('should allow a user to register', () => {
    cy.register_user(username, email);

    // assert user is redirected to '/'
    cy.contains('All Users');
    cy.contains(username);
    cy.get('.navbar-burger').click();
    cy.get('.navbar-menu').within(() => {
      cy.get('.navbar-item').contains('User Status')
        .get('.navbar-item').contains('Log Out')
        .get('.navbar-item').contains('Log In').should('not.be.visible')
        .get('.navbar-item').contains('Register').should('not.be.visible');
    });
  });
});
