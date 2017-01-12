Template.steedosAbout.helpers
	steedosInfoVersion: ->
		Steedos.Info.version

	steedosCommitDate: ->
		if Steedos.Info.commit
			Steedos.Info.commit.date

	steedosBuildDate: ->
		if Steedos.Info.build
			Steedos.Info.build.date
