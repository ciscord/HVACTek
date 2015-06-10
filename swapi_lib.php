<?php
class swapi_api_lib{
	var $CI;

	var $_url 			= '';
	var $_port 			= '';

	var $_agent_name 	= '';
	var $_agent_pass 	= '';
	var $_master_id 	= '';
	var $_company_no 	= '';
	var $_username 		= '';
	var $_password 		= '';

	var $_connect_id 	= '';
	var $_session_id 	= '';

	var $_headers		= array(
		"Content-type: text/xml;charset=\"utf-8\"",
		"Accept: text/xml",
		"Cache-Control: no-cache",
		"Pragma: no-cache");

	var $_requests 		= array(
		'connect' => '<Connect Version="string">
		<AgentName>[agent_name]</AgentName>
		<AgentPassword>[agent_pass]</AgentPassword>
		<MasterID>[master_id]</MasterID>
		<Mode>tutorial</Mode>
		<ServerURL>string</ServerURL></Connect>
		',
		'begin_session' => '<ConnectionRequest Version="string" ConnectionID="[connection_id]" RequestID="string">
		<BeginSession Version="string">
			<ConnectionID>[connection_id]</ConnectionID>
			<CompanyNo>[company_no]</CompanyNo>
			<Username>[username]</Username>
			<UserPassword>[password]</UserPassword>
			<Terminal>string</Terminal>
			<RemoteTC>0</RemoteTC>
		</BeginSession></ConnectionRequest>
		',
		'pricebook' => '<SessionRequest Version="string" SessionID="[session_id]" RequestID="string">
		<PricebookTaskQuery Filter="string" Max="string" OrderBy="string" StyleNo="string" StyleOptions="string">
			<LastUpdated>[date]</LastUpdated>
		</PricebookTaskQuery></SessionRequest>'
		);

	public function __construct()
	{
		$this->CI =& get_instance();

		$this->CI->config->load('swapi');

		$this->_url 			= $this->CI->config->item('swapi_url');
		$this->_port 			= $this->CI->config->item('swapi_port');

		$this->_agent_name 		= $this->CI->config->item('swapi_agent_name');
		$this->_agent_pass 		= $this->CI->config->item('swapi_agent_pass');
		$this->_master_id 		= $this->CI->config->item('swapi_master_id');

		$this->_company_no 		= $this->CI->config->item('swapi_company_no');
		$this->_username 		= $this->CI->config->item('swapi_username');
		$this->_password 		= $this->CI->config->item('swapi_password');
	}

	public function get_pricebook($_date){

		if ($this->_session_id == ''){
			$_conn = $this->request_connection();

			$_conn = simplexml_load_string($_conn);

			if ($_conn['Successful'] && $_conn['ResultCode']){
				$this->_connect_id = $_conn->ConnectionID;

				if ($this->_connect_id){
					$_sess = $this->request_session();

					$_sess = simplexml_load_string($_sess);

					if ($_sess['Successful'] && $_sess['ResultCode']){
						$this->_session_id = $_sess->SessionID;
					}
				}
			}
		}

		if ($this->_session_id !== FALSE){

			$_request = str_replace(array('[session_id]','[date]'), 
				array($this->_session_id, $_date), $this->_requests['pricebook']);

			return $this->do_request($_request);
		}

		return FALSE;
	}

	public function request_connection(){
		$_request = str_replace(array('[master_id]', '[agent_name]', '[agent_pass]'), 
			array($this->_master_id, $this->_agent_name, $this->_agent_pass), $this->_requests['connect']);

		return $this->do_request($_request);
	}

	public function request_session(){
		$_request = str_replace(array('[company_no]','[username]','[password]', '[connection_id]'), 
			array($this->_company_no, $this->_username, $this->_password, $this->_connect_id), $this->_requests['begin_session']);

		return $this->do_request($_request);
	}

	public function parse_xml($_xml){
		$_xml = simplexml_load_string($_xml);

		if ($_xml){
			return $_xml;
		}

		return FALSE;
	}

	private function do_request($_request){

		$ch = curl_init();

		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($ch, CURLOPT_URL, $this->_url . ':' . $this->_port);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_TIMEOUT, 10);
		curl_setopt($ch, CURLOPT_POST, true);

		curl_setopt($ch, CURLOPT_POSTFIELDS, $_request);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array_merge($this->_headers,
			array("Content-length: " . strlen($_request))));


        // converting
		$response = curl_exec($ch);

        // Check for errors and display the error message
		if($errno = curl_error($ch)) {
			$error_message = $errno;
			echo "cURL error ({$errno}):\n {$error_message}";
		}

		curl_close($ch);

		return $response;
	}

}