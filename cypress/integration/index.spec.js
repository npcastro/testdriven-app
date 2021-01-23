describe('Index', () => {
  it('should display the page correctly if a user is not logged in', () => {
    cy
      .visit('/')
      .get('.navbar-burger').click()
      .get('a').contains('User Status').should('not.be.visible')
      .get('a').contains('Log Out').should('not.be.visible')
      .get('a').contains('Register')
      .get('a').contains('Log In')
      .get('a').contains('Swagger')
      .get('.notification is-success').should('not.be.visible');
  });

  it('users should be able to view the about page', () => {
    cy.visit('/')
      .get('.navbar-burger').click()
      .get('a[href="/about"]').click()
  });

  it('users should be able to view the Register page', () => {
    cy.visit('/')
      .get('.navbar-burger').click()
      .get('a[href="/register"]').click()

    cy.get('h1').contains('Register');
  });
});
