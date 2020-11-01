import React from 'react';
import { shallow, mount } from 'enzyme';
import renderer from 'react-test-renderer';
import { MemoryRouter as Router } from 'react-router-dom';

import FormErrors from '../forms/FormErrors';
import { registerFormRules, loginFormRules } from '../forms/form-rules.js';

const registerFormProps = {
  formType: 'Register',
  formRules: registerFormRules,
}

const loginFormProps = {
  formType: 'Login',
  formRules: loginFormRules,
}

const testData = [
  {
    formType: 'Register',
    formRules: registerFormRules,
  },
  {
    formType: 'Login',
    formRules: loginFormRules,
  }
]

testData.forEach((el) => {
  test(`FormErrors (with ${el.formType} form) renders properly`, () => {
    const wrapper = shallow(<FormErrors {...el} />);
    const ul = wrapper.find('ul');
    expect(ul.length).toBe(1);
    const li = wrapper.find('li');
    expect(li.length).toBe(el.formRules.length);

    el.formRules.forEach((rule) => {
      expect(li.get(rule.id - 1).props.children).toContain(rule.name);
    });
  });

  test(`FormErrors (with ${el.formType} form) renders a snapshot properly`, () => {
    const tree = renderer.create(
      <Router><FormErrors {...el} /></Router>
    ).toJSON();
    expect(tree).toMatchSnapshot();
  });
});
