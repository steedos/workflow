TemplateManager = {};

formId = 'instanceform';


TemplateManager._template =
    default: '''
		<div class="box-header  with-border">
            <div class="applicant-wrapper">
                <label class="control-label">{{_t "instance_initiator"}}&nbsp;:</label>
                {{>Template.dynamic  template="afSelectUser" data=applicantContext}}
            </div>
            <span class="help-block"></span>
        </div>
		{{#each steedos_form.fields}}
		    {{#if includes this.type 'section,table'}}
		        <div class="col-md-12">
		            {{> afFormGroup name=this.code label=false}}
		        </div>
		    {{else}}
		        <div class="{{#if this.is_wide}}col-md-12{{else}}col-md-6{{/if}}">
		        {{> afFormGroup name=this.code}}
		        </div>
		    {{/if}}
		    
		{{/each}}
	'''
    table: '''
		<div class="box-header  with-border">
            <div class="applicant-wrapper">
			    <label class="control-label">{{_t "instance_initiator"}}&nbsp;:</label>
			    {{>Template.dynamic  template="afSelectUser" data=applicantContext}}
			</div>
        </div>
		<table class="form-table">
		    {{#each table_fields}}
		        {{#if includes this.type 'section,table'}}
		            {{{tr_start}}}
		                <td class="td-childfield" colspan = '{{td_colspan}}'>
		                   {{> afFormGroup name=this.code label=false}}
		                </td>
		            {{{tr_end}}}
		        {{else}}
		            {{{tr_start}}}
		                <td class="td-title {{#if is_required}}is-required{{/if}}">
		                    {{afFieldLabelText name=this.code}}
		                </td>
		                <td class="td-field {{permission}}" colspan = '{{td_colspan}}'>
		                    {{> afFormGroup name=this.code label=false}}
		                </td>
		            {{{tr_end}}}
		        {{/if}}
		        
		    {{/each}}
		</table>
	'''

TemplateManager._templateHelps =
    applicantContext: ->
        steedos_instance = WorkflowManager.getInstance();
        data = {
            name: 'ins_applicant',
            atts: {
                name: 'ins_applicant',
                id: 'ins_applicant',
                class: 'selectUser form-control',
                style: 'padding:6px 12px;width:140px;display:inline'
            }
        }
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
    doc_values = WorkflowManager_format.getAutoformSchemaValues();
    obj["tableValues"] = if doc_values then doc_values[obj.code] else []
    obj["formId"] = formId;
    return obj;

instance: ->
    Session.get("change_date")
    if (Session.get("instanceId"))
        steedos_instance = WorkflowManager.getInstance();
        return steedos_instance;

equals: (a, b) ->
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


TemplateManager.getTemplate = (flowId) ->
    flow = db.flows.findOne(flowId);

    if Session?.get("instancePrint")
        if flow?.print_template
            return flow.print_template
        else
            return TemplateManager._template.table
    else
        if Steedos.isMobile()
            return TemplateManager._template.default

        if flow?.instance_template
            return flow.instance_template

        if flow?.instance_style
            return TemplateManager._template[flow.instance_style]
        else
            return TemplateManager._template.default

TemplateManager.exportTemplate = (flowId) ->
    template = TemplateManager.getTemplate(flowId);

    flow = WorkflowManager.getFlow(flowId);

    if flow?.instance_template
        return template;

    return template;