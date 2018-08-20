JsonRoutes.add("post", "/api/workflow/sub_table_sort", (req, res, next) ->
	try
        console.log "=========子表=========="
        console.log "req?.query?.subTable",req?.query?.subTable
        console.log "=========子表总分列=========="
        console.log "req?.query?.sumCol",req?.query?.sumCol
        console.log "=========子表排序列=========="
        console.log "req?.query?.sortCol",req?.query?.sortCol
        console.log "=========子表单列需要计算的和=========="
        console.log "req?.query?.singleCols",req?.query?.singleCols
        
        
        sub_table = req?.query?.subTable
        if !sub_table
            console.log "=====sub_table======"
            throw new Meteor.Error('table sort error!', 'webhook 未配置 subTable 字段' );
        
        sum_col = req?.query?.sumCol
        if !sum_col
            console.log "=====sum_col======"

            throw new Meteor.Error('table sort error!', 'webhook 未配置 sumCol 字段' );
        
        sort_col = req?.query?.sortCol
        if !sort_col
            console.log "=====sort_col======"

            throw new Meteor.Error('table sort error!', 'webhook 未配置 sortCol 字段' );
        
        single_cols = req?.query?.singleCols
        if !single_cols
            console.log "=====single_cols======"

            throw new Meteor.Error('table sort error!', 'webhook 未配置 singleCols 字段' );
        
        ins = req?.body?.instance
        
        sub_table_values = ins.values[sub_table]
        
        if sub_table_values?.length > 0
            # 循环每一行，加上
            columns = single_cols.split(';') || []
            
            sub_table_values.forEach (obj)->
                sum = 0
                columns.forEach (col)->

                    num = parseInt(obj[col])
                    if !isNaN(num)
                        sum = sum + num

                obj[sum_col] = sum.toString()
            
            length = sub_table_values?.length
            
            # # 根据 sub_table_values 进行排序
            # ======================
            

        console.log "success"
        JsonRoutes.sendResult res, {
            code: 200,
            data: {
                'success': '计算成功'
            }
        }

    catch e
        JsonRoutes.sendResult res, {
            code: 200,
            data: {
                errors: [e]
            }
        }
)