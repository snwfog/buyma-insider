require_relative './setup'

merchant_table = 'merchants'
unless r.table_list().run.include?(merchant_table)
  r.table_create(merchant_table, primary_key: :id).run rescue puts $!
end

r.table('merchants')
  .insert([{ 'created_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
             'id'         => 'sho',
             'name'       => 'shoeme',
             'updated_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00'
           }, {
             'created_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
             'id'         => 'get',
             'name'       => 'getoutside',
             'updated_at' => 'Sat Mar 11 2017 20:35:13 GMT+00:00'
           }, {
             'created_at' => 'Sat Mar 11 2017 20:35:12 GMT+00:00',
             'id'         => 'sse',
             'name'       => 'ssense',
             'updated_at' => 'Sat Mar 11 2017 20:35:12 GMT+00:00'
           }, {
             'created_at'  => 'Sat Mar 11 2017 20:35:13 GMT+00:00',
             'id'          => 'zar',
             'name'        => 'zara',
             'updated_at': 'Sat Mar 11 2017 20:35:13 GMT+00:00'
           }], conflict: 'replace').run

