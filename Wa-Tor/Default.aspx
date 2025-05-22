<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Code Retreat 4/21/2018</title>
    <link rel="stylesheet" href="css/main.css" />
    <telerik:RadStyleSheetManager id="RadStyleSheetManager1" runat="server" />
    <script type="text/javascript">
        var haveFile = false;
        var timerid;
        var haveImages = false;
        var isPlaying = false;
        var counter = -1;
        var timeInt = 200;
        var doLoop = false;
        function fileSelected(sender, args) {
            haveFile = true;
            document.getElementById('<%#lbUploadFile.ClientID%>').style.backgroundColor = '#645a72';
            var savemsg = document.getElementById('<%#lblUploadError.ClientID%>');
            try {
                savemsg.style.display = 'none';
            } catch (error) { }
        }
        function fileRemoved(sender, args) {
            haveFile = false;
            document.getElementById('<%#lbUploadFile.ClientID%>').style.backgroundColor = '#f0f0f0';
        }
        function evalButtons() {
            if (counter > 0) {
                document.getElementById('<%#lbFirst.ClientID%>').style.backgroundColor = '#645a72';
                document.getElementById('<%#lbPrev.ClientID%>').style.backgroundColor = '#645a72';
            } else {
                document.getElementById('<%#lbFirst.ClientID%>').style.backgroundColor = '#f0f0f0';
                document.getElementById('<%#lbPrev.ClientID%>').style.backgroundColor = '#f0f0f0';
            }
            if (counter == imgArray.length - 1) {
                document.getElementById('<%#lbNext.ClientID%>').style.backgroundColor = '#f0f0f0';
                document.getElementById('<%#lbLast.ClientID%>').style.backgroundColor = '#f0f0f0';
            } else {
                document.getElementById('<%#lbNext.ClientID%>').style.backgroundColor = '#645a72';
                document.getElementById('<%#lbLast.ClientID%>').style.backgroundColor = '#645a72';
            }
        }
        function gotImages() {
            document.getElementById('<%#lbPlay.ClientID%>').style.backgroundColor = '#645a72';
            evalButtons();
        }
        function notImages() {
            document.getElementById('<%#lbPlay.ClientID%>').style.backgroundColor = '#f0f0f0';
            document.getElementById('<%#lbStop.ClientID%>').style.backgroundColor = '#f0f0f0';
            document.getElementById('<%#lbFirst.ClientID%>').style.backgroundColor = '#f0f0f0';
            document.getElementById('<%#lbPrev.ClientID%>').style.backgroundColor = '#f0f0f0';
            document.getElementById('<%#lbNext.ClientID%>').style.backgroundColor = '#f0f0f0';
            document.getElementById('<%#lbLast.ClientID%>').style.backgroundColor = '#f0f0f0';
        }
        function addFrame() {
            counter += 1;
            if (counter > imgArray.length - 1) {
                counter = 0;
            }
        }
        function delFrame() {
            counter -= 1;
            if (counter < 0) {
                counter = imgArray.length - 1;
            }
        }
        function doSpdLow() {
            timeInt = 400;
        }
        function doSpdMedium() {
            timeInt = 200;
        }
        function doSpdHigh() {
            timeInt = 100;
        }
        function stopTimer() {
            try {
                clearInterval(timerid);
            } catch (error) { }
        }
        function doPlay() {
            if (haveImages) {
                if (!isPlaying) {
                    doLoop = document.getElementById('chkLoop').checked;
                    isPlaying = true;
                    document.getElementById('<%#lbPlay.ClientID%>').style.backgroundColor = '#f0f0f0';
                    document.getElementById('<%#lbFirst.ClientID%>').style.backgroundColor = '#f0f0f0';
                    document.getElementById('<%#lbPrev.ClientID%>').style.backgroundColor = '#f0f0f0';
                    document.getElementById('<%#lbNext.ClientID%>').style.backgroundColor = '#f0f0f0';
                    document.getElementById('<%#lbLast.ClientID%>').style.backgroundColor = '#f0f0f0';
                    document.getElementById('<%#lbStop.ClientID%>').style.backgroundColor = '#645a72';
                    document.getElementById('grpSpeed').disabled = true;
                    timerid = setInterval(
                        function () {
                            var doAnimate = true;
                            if (doLoop) {
                                addFrame();
                            }
                            else {
                                if (counter < imgArray.length - 1) {
                                    addFrame();
                                } else {
                                    doAnimate = false;
                                    doStop();
                                    counter = 0;
                                }
                            }
                            if (doAnimate) {
                                imgFrame.src = imgArray[counter].src;
                                document.getElementById('lblFrame').innerText = nameArray[counter];
                            }
                        }, timeInt);
                }
            }
        }
        function doStop() {
            if (haveImages) {
                if (isPlaying) {
                    isPlaying = false;
                    document.getElementById('<%#lbPlay.ClientID%>').style.backgroundColor = '#645a72';
                    document.getElementById('<%#lbStop.ClientID%>').style.backgroundColor = '#f0f0f0';
                    evalButtons();
                    document.getElementById('grpSpeed').disabled = false;
                    try {
                        clearInterval(timerid);
                    } catch (error) { }
                }
            }
        }
        function doPrev() {
            if (haveImages && !isPlaying) {
                if (counter > 0) {
                    delFrame();
                    imgFrame.src = imgArray[counter].src;
                    document.getElementById('lblFrame').innerText = nameArray[counter];
                    evalButtons();
                }
            }
        }
        function doNext() {
            if (haveImages && !isPlaying) {
                if (counter < imgArray.length - 1) {
                    addFrame();
                    imgFrame.src = imgArray[counter].src;
                    document.getElementById('lblFrame').innerText = nameArray[counter];
                    evalButtons();
                }
            }
        }
        function doFirst() {
            if (haveImages && !isPlaying) {
                counter = 0;
                imgFrame.src = imgArray[counter].src;
                document.getElementById('lblFrame').innerText = nameArray[counter];
                evalButtons();
            }
        }
        function doLast() {
            if (haveImages && !isPlaying) {
                counter = imgArray.length - 1;
                imgFrame.src = imgArray[counter].src;
                document.getElementById('lblFrame').innerText = nameArray[counter];
                evalButtons();
            }
        }
        function doUpload() {
            if (haveFile) {
                doStop();
                document.getElementById('<%#lblUploadMsg.ClientID%>').innerText = 'Processing File, Please Wait...';
                haveFile = false;
                return true;
            } else {
                return false;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>

    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="lbUploadFile">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="pnlMain" UpdatePanelCssClass="" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div class="crtitle">Asheville Coder's League - Code Retreat (4/21/2018)</div>
    <div class="crdesc">WA-TOR Exercise</div>

    <asp:Panel ID="pnlMain" runat="server">
        <div class="frtitle"><span id="lblFrame">Frame Title:</span></div>
        <div class="imagecell"><img id="imgFrame" src="template/empty.png" width="450" height="300" border="1" /></div>
        <div class="speedcell">
            <fieldset id="grpSpeed" class="radiogroup">
                <input type="radio" id="spdLow" name="grpSpeed" value="300" onclick="doSpdLow();" /><label for="spdLow">Low</label>
                <input type="radio" id="spdMedium" name="grpSpeed" value="200" checked="checked" onclick="doSpdMedium();" /><label for="spdMedium">Medium</label>
                <input type="radio" id="spdHigh" name="grpSpeed" value="100" onclick="doSpdHigh();" /><label for="spdHigh">High</label>&nbsp;&nbsp;
                &nbsp;&nbsp;<input type="checkbox" id="chkLoop" />Loop Playback
            </fieldset>
        </div>
        <div class="buttonscell">
            <asp:LinkButton ID="lbPlay" CssClass="disbutton" Width="80" runat="server" Text="Play" OnClientClick="doPlay();return false;"></asp:LinkButton>
            <asp:LinkButton ID="lbStop" CssClass="disbutton" Width="80" runat="server" Text="Stop" OnClientClick="doStop();return false;"></asp:LinkButton>
            <asp:LinkButton ID="lbFirst" CssClass="disbutton" Width="80" runat="server" Text="First" OnClientClick="doFirst();return false;"></asp:LinkButton>
            <asp:LinkButton ID="lbPrev" CssClass="disbutton" Width="80" runat="server" Text="Prev" OnClientClick="doPrev();return false;"></asp:LinkButton>
            <asp:LinkButton ID="lbNext" CssClass="disbutton" Width="80" runat="server" Text="Next" OnClientClick="doNext();return false;"></asp:LinkButton>
            <asp:LinkButton ID="lbLast" CssClass="disbutton" Width="80" runat="server" Text="Last" OnClientClick="doLast();return false;"></asp:LinkButton>
        </div>

        <div class="uploadmsg">Upload Data File:</div>
        <div class="uploadcell"><telerik:RadAsyncUpload RenderMode="Lightweight" ID="RadAsyncUpload1" TargetFolder="Uploads" runat="server" MaxFileInputsCount="1" OnFileUploaded="RadAsyncUpload1_FileUploaded" OnClientFileSelected="fileSelected" OnClientFileUploadRemoved="fileRemoved"></telerik:RadAsyncUpload></div>
        <div class="uploadmsg"><asp:Label ID="lblUploadMsg" runat="server" Text="&nbsp;" Visible="true"></asp:Label><asp:Label ID="lblUploadError" runat="server" CssClass="errormsg" Text="Bad Message" Visible="false"></asp:Label></div>
        <div class="uploadbtn">
            <asp:LinkButton ID="lbUploadFile" CssClass="disbutton" Width="200" runat="server" Text="Upload and Process" OnClick="lbUploadFile_Click" OnClientClick="return doUpload();"></asp:LinkButton>
            <asp:LinkButton ID="lbGenerateFile" CssClass="mainbutton" Width="200" runat="server" Text="Generate Random" OnClick="lbUploadFile_Click"></asp:LinkButton>
        </div>
    </asp:Panel>

    </form>
</body>
</html>
