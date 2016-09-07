# if (steedos_form)
#   formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", steedos_form.fields);

formId = 'instanceform';

Template.instanceform.helpers
    applicantContext: ->
        steedos_instance = WorkflowManager.getInstance();
        data = {name:'ins_applicant',atts:{name:'ins_applicant',id:'ins_applicant',class:'selectUser form-control',style:'padding:6px 12px;width:140px;display:inline'}} 
        if not steedos_instance || steedos_instance.state != "draft"
            data.atts.disabled = true
        return data;

    instanceId: ->
        return 'instanceform';#"instance_" + Session.get("instanceId");

    form_types: ->
        if ApproveManager.isReadOnly()
            return 'disabled';
        else
            return 'method';
    
    steedos_form: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            return form_version

    innersubformContext: (obj)->
        doc_values = WorkflowManager_format.getAutoformSchemaValues();;
        obj["tableValues"] = if doc_values then doc_values[obj.code] else []
        obj["formId"] = formId;
        return obj;

    instance: ->
        Session.get("change_date")
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;

    equals: (a,b) ->
        return (a == b)

    includes: (a, b) ->
        return b.split(',').includes(a);

    fields: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            return new SimpleSchema(WorkflowManager_format.getAutoformSchema(form_version));
            
    doc_values: ->
        WorkflowManager_format.getAutoformSchemaValues();

    instance_box_style: ->
        box = Session.get("box")
        if box == "inbox" || box == "draft"
            judge = Session.get("judge")
            if judge
                if (judge == "approved")
                    return "box-success" 
                else if (judge == "rejected")
                    return "box-danger"
        ins = WorkflowManager.getInstance();
        if ins && ins.final_decision
            if ins.final_decision == "approved"
                return "box-success" 
            else if (ins.final_decision == "rejected")
                return "box-danger"

    #is_disabled: ->
    #    ins = WorkflowManager.getInstance();
    #    if !ins
    #        return;
    #    if ins.state!="draft"
    #        return "disabled";
    #    return;
    

    #attachments: ->
    #    # instance 修改时重算
    #    WorkflowManager.instanceModified.get();
    #    
    #    instance = WorkflowManager.getInstance();
    #    return instance.attachments;

Template.instanceform.onRendered ->
    t = this;

    #t.subscribe "instance_data", Session.get("instanceId"), ->
    #    Tracker.afterFlush -> 
    instance = WorkflowManager.getInstance();
    if !instance
        return;

    #$("#ins_applicant").select2().val(instance.applicant).trigger('change');
    #$("#ins_applicant").val(instance.applicant);
    $("input[name='ins_applicant']")[0].dataset.values = instance.applicant;
    $("input[name='ins_applicant']").val(instance.applicant_name)
    

    ApproveManager.error = {nextSteps:'',nextStepUsers:''};
    if !ApproveManager.isReadOnly()
        currentApprove = InstanceManager.getCurrentApprove();

        judge = currentApprove.judge
        currentStep = InstanceManager.getCurrentStep();
        form_version = WorkflowManager.getInstanceFormVersion();

        Form_formula.initFormScripts("instanceform", "onload");

        formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);
        Form_formula.run("", "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        #在此处初始化session 中的 form_values 变量，用于触发下一步步骤计算
        Session.set("form_values", AutoForm.getFormValues("instanceform").insertDoc);

Template.instanceform.events
    'change .instance-form .form-control,.instance-form .checkbox input,.instance-form .af-radio-group input,.instance-form .af-checkbox-group input': (event)->
        if ApproveManager.isReadOnly()
            return ;
        
        code = event.target.name;

        type = event.target.type;

        if type == 'number'
            v = event.target.value;
            try
                if !v
                    v = 0.00;
                    
                if typeof(v) == 'string'
                    v = parseFloat(v)

                step = event.target.step
                
                if step
                    v = v.toFixed(step.length - 2)
                else
                    v = v.toFixed(0)

                event.target.value = v;
            catch error
                console.log(v + error)


        console.log("instanceform form-control change, code is " + code);

        InstanceManager.checkFormFieldValue(event.target);

        InstanceManager.runFormula(code);

        if code == 'ins_applicant'
            Session.set("ins_applicant", InstanceManager.getApplicantUserId());

        # form_version = WorkflowManager.getInstanceFormVersion();
        # formula_fields = []
        # if form_version
        #     formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);
        # Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        # Session.set("form_values", AutoForm.getFormValues("instanceform").insertDoc);
        #InstanceManager.updateNextStepTagOptions();

    # 子表删除行时，执行主表公式计算
    # 'click .steedosTable-remove-item': (event, template)->
    #     Session.set("instance_change", true);
    #     console.log("instanceform form-control change");
    #     code = event.target.name;

    #     InstanceManager.runFormula(code);

        # form_version = WorkflowManager.getInstanceFormVersion();
        # formula_fields = []
        # if form_version
        #     formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);

        # autoform-inputs 中 markChanged 函数中，对template 的更新延迟了100毫秒，
        # 此处为了能拿到删除列后最新的数据，此处等待markChanged执行完成后，再进行计算公式.
        # 此处给定等待101毫秒,只是为了将函数添加到 Timer线程中，并且排在markChanged函数之后。

        # setTimeout ->
        #    Form_formula.run(code, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);
        # ,101