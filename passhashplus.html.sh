#!/bin/bash
cat <<-EOF
<!--
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Password Hasher Plus
 *
 * The Initial Developer of the Original Code is Eric Woodruff.
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s): (none)
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */
-->
<html>
<head>
<style>
* { font-family: Arial; font-size: 12px; }
</style>
<script type="text/javascript">
$(cat lib/jquery-1.4.2.min.js)
</script>
<script type="text/javascript">
$(cat lib/sha1.js)
</script>
<script type="text/javascript">
$(cat lib/passhashcommon.js)
</script>
<script type="text/javascript">
$(cat common.js)
</script>
</head>

<body>
<h1>This is the Password Hasher Plus portable HTML page</h1>
<div style="">
	<table border="0">
		<tr>
			<td></td>
			<td>
				<p>The private key is not used/needed if the site tag begins with "compatible:"</p>
			</td>
		</tr>
		<tr>
			<td>Private Key:</td>
			<td>
				<input id="seed" type="password" class="nopasshash" size="48" maxlength="45"/>
				<input type="button" value="a" id="unmaskseed" title="Disable/enable Masking"/>
			</td>
		</tr>
		<tr>
			<td>Site Tag:</td>
			<td>
				<input style="width: 134px;" type="password" class="nopasshash" id="site" value="" />
				<input type="button" value="a" id="unmasksite" title="Disable/enable Masking"/>
				<input type="button" value="Bump" id="bump" />
			</td>
		</tr>
		<tr>
			<td>Passphrase:</td>
			<td>
				<input style="width: 134px;" type="password" class="nopasshash" id="input" value="" />
				<input type="button" value="a" id="unmaskpassword" title="Disable/enable Masking"/>
			</td>
		</tr>
		<tr>
			<td>Password Length:</td>
			<td><select id="length">
				<option value="2">2</option>
				<option value="4">4</option>
				<option value="6">6</option>
				<option value="8">8</option>
				<option value="10">10</option>
				<option value="12">12</option>
				<option value="14">14</option>
				<option value="16">16</option>
				<option value="18">18</option>
				<option value="20">20</option>
				<option value="22">22</option>
				<option value="24">24</option>
				<option value="26">26</option>
			</select></td>
		</tr>
		<tr>
			<td>Password Strength:</td>
			<td><select id="strength">
				<option value="2">Alphanumeric+Special</option>
				<option value="1">Alphanumeric</option>
				<option value="0">Numeric</option>
			</select></td>
		</tr>
		<tr>
			<td>
			Hash Result:
			</td>
			<td>
				<input id="hash" type="text" size="48" maxlength="45"/>
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				Click the hash result then copy it to the clipboard by pressing 'Ctrl + c'.
			</td>
		</tr>
	</table>
</div>
</body>

<script type="text/javascript">
\$('#length').val (12);
\$('#strength').val (2);

function togglefield () {
	var button = this;
	var field = \$(this).prev ("input").get (0);
	if ("text" == field.type) {
		field.type = "password";
		button.value = "a";
		button.title = "Show contents (Ctrl + *)";
	} else {
		field.type = "text";
		button.value = "*";
		button.title = "Mask contents (Ctrl + *)";
	}
}

\$('#unmaskseed').click (togglefield);
\$('#unmasksite').click (togglefield);
\$('#unmaskpassword').click (togglefield);

\$('#bump').click (function () {
	var re = new RegExp ("^([^:]+?)(:([0-9]+))?$");
	var site = \$('#site').val ();
	if (site.startsWith ("compatible:")) {
		site = site.substringAfter ("compatible:");
	}
	var matcher = re.exec (site);
	var bump = 1;
	if (null != matcher[3]) {
		site = matcher[1];
		bump += parseInt (matcher[3]);
	}
	\$("#site").val (site + ":" + bump);
});

var sitefield = \$('#site').get (0);
var seedfield = \$('#seed').get (0);
var lengthfield = \$('#length').get (0);
var strengthfield = \$('#strength').get (0);
var inputfield = \$('#input').get (0);
var hashfield = \$('#hash').get (0);

hashfield.readOnly = true;

function update () {
	var config = new Object ();
	config.site = sitefield.value;
	config.seed = seedfield.value;
	config.length = lengthfield.value;
	config.strength = strengthfield.value;
	var input = inputfield.value;
	var hash = generate_hash (config, input);
	hashfield.value = hash;
}

sitefield.addEventListener ("keydown", update);
seedfield.addEventListener ("keydown", update);
inputfield.addEventListener ("keydown", update);
sitefield.addEventListener ("keyup", update);
seedfield.addEventListener ("keyup", update);
inputfield.addEventListener ("keyup", update);
sitefield.addEventListener ("change", update);
seedfield.addEventListener ("change", update);
inputfield.addEventListener ("change", update);
lengthfield.addEventListener ("change", update);
strengthfield.addEventListener ("change", update);

hashfield.addEventListener ("click", function () {
	hashfield.select ();
});

</script>
</html>
EOF
