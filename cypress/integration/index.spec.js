describe('Index', () => {
  it('users should be able to view the "/" page', () => {
    cy.visit('/')
      .get('h1').contains('All Users');

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
