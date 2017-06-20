import { Template } from 'meteor/templating'
import { ReactiveVar } from 'meteor/reactive-var'

import './main.html';

Meteor.startup ->
	if SC.setupBodyClassNames
		SC.setupBodyClassNames()