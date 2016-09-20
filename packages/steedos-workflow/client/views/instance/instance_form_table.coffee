# if (steedos_form)
#   formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", steedos_form.fields);

formId = 'instanceform';

Template.instanceform_table.helpers
    applicantContext: ->
        steedos_instance = WorkflowManager.getInstance();
        data = {name:'ins_applicant',atts:{name:'ins_applicant',id:'ins_applicant',class:'selectUser form-control ins_applicant'}} 
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

    unequals: (a,b) ->
        return !(a == b)

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


    table_fields: ->
        form_version = WorkflowManager.getInstanceFormVersion();
        if form_version
            fields = _.clone(form_version.fields);

            fields.forEach (field, index) ->

                if field.formula
                    field.permission = "readonly";

                if Steedos.isMobile()
                    field.td_colspan = 3;
                    if index != 0 
                        field.tr_start = "<tr>";
                        field.tr_end = "</tr>";
                else
                    pre_fields = fields.slice(0, index);

                    pre_wide_fields = pre_fields.filterProperty("is_wide", true);

                    tr_start = "";

                    tr_end = "";

                    # 先计算当前字段是否为宽字段
                    before_field = null; 
                    after_field = null;

                    if index > 0
                        before_field = fields[index - 1]

                    if index < fields.length - 1
                        after_field = fields[index + 1]

                    # 如果当前字段是分组、表格、宽字段
                    if field.type == 'section' || field.type == 'table'
                        td_colspan = 4;
                    else if field.is_wide
                        td_colspan = 3;
                    else
                        # 前后都是宽字段
                        if before_field && after_field && before_field.is_wide && after_field.is_wide
                            field.is_wide = true;
                            td_colspan = 3;

                        # 当前是tr 下的 第一个td & 后边的字段是宽字段
                        if (pre_fields.length + pre_wide_fields.length) % 2 == 0 && after_field && after_field.is_wide
                            field.is_wide = true;
                            td_colspan = 3;

                        # 当前是tr 下的 第一个td & 当前字段是最后一个字段
                        if (pre_fields.length + pre_wide_fields.length) % 2 == 0 && after_field == null
                            field.is_wide = true;
                            td_colspan = 3;

                    field.td_colspan = td_colspan;


                    if index == 0
                        # tr_start = "<tr>"; 由于Template的编译bug，导致每次给一个tr开始时，会自动补头或补尾。因此在第一行返回一个空字符串.
                        tr_start = "";
                    else 
                        if (pre_fields.length + pre_wide_fields.length) % 2 == 0 || field.is_wide
                            if field.type == 'table'
                                tr_start = "<tr class = \"tr-child-table\">";
                            else
                                tr_start = "<tr>";

                    field.tr_start = tr_start;


                    if index + 1 == fields.length || field.type == 'section' || field.type == 'table' || field.is_wide
                        tr_end = "</tr>";

                    if (pre_fields.length + pre_wide_fields.length) % 2 != 0
                        tr_end = "</tr>";

                    field.tr_end = tr_end;


            console.log(fields)
            return fields;

Template.instanceform_table.onRendered ->
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

Template.instanceform_table.events
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
