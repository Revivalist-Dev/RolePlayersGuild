<%@ Page Title="Customize Profile on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyCharacters.EditCharacter.CustomProfile.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <script src="/js/jquery.are-you-sure.js"></script>
    <script src="/js/ays-beforeunload-shim.js"></script>
    <script>
        $(function () {
            // Example 1 - ... in one line of code
            $('#form1').areYouSure();
        });
    </script>
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <h1>Custom Profile</h1>
    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a class="btn btn-default" href="/My-Characters/Edit-Character/?Mode=Edit&CharID=<%= Request.QueryString["CharID"] %>">Back To Character</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
            <a class="btn btn-info" data-toggle="modal" data-target="#InfoModal">What is this?</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a class="btn btn-info" data-toggle="modal" data-target="#PlaceholderModal">Available Placeholders</a>
        </div>
    </div>

    <div class="checkbox">
        <label>
            <asp:CheckBox ID="chkEnableCustomProfile" ClientIDMode="Static" runat="server" Text="" />
            Enable my custom profile.
        </label>
    </div>

    <div class="form-group">
        <label for="txtBackground">Profile CSS</label>
        <asp:TextBox ID="txtProfileCSS" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder=".Greeting {display: hidden;}" Rows="12" ValidateRequestMode="Disabled"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="txtBackground">Profile HTML</label>
        <asp:TextBox ID="txtProfileHTML" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="<p class=&quot;Greeting&quot;>Hello, World.</p>" Rows="12" ValidateRequestMode="Disabled"></asp:TextBox>
    </div>

    <div class="ButtonPanel clearfix">
        <div class="col-xl-3 col-sm-4 col-xs-12">
            <a class="btn btn-default" target="_blank" href="/Character/?id=<%= Request.QueryString["CharID"] %>">View Profile</a>
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12">
        </div>
        <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
            <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnSaveProfile_Click" />
        </div>
    </div>

    <!-- Modals -->
    <div class="modal fade" id="InfoModal" tabindex="-1" role="dialog" aria-labelledby="InfoLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="InfoLabel">What is this?</h4>
                </div>
                <div class="modal-body">
                    <p>Using this screen, you can creat your own custom CSS and HTML for your profile. You can either program it from scratch or use some existing code. Please keep in mind, however, that you do NOT need the <strong>&lt;style&gt;</strong> tags for the CSS text box, as it is already aware of what you are using it for.</p>
                    <p><strong>Enable my custom profile.</strong></p>
                    <p>By checking this checkbox and clicking on "Save Profile" you will replace your current, auto-generated profile with your brand new customized profile. Make sure you do not turn this feature on if you haven't finished your profile, as it may make it difficult for others to contact you.</p>
                    <p><strong>Placeholders</strong></p>
                    <p>Placeholders can be used to support dynamic content. This will allow you to change your character's profile easily using the character editing screen and not have to worry about touching the code to reflect the changes you've made.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="PlaceholderModal" tabindex="-1" role="dialog" aria-labelledby="PlaceholderLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="PlaceholderLabel">Placeholders</h4>
                </div>
                <div class="modal-body PlaceholdersDialog">
                    <p>The currently available placeholders are shown below (we'll be adding explanations to these soon):</p>
                    <p><strong>Character-Related</strong></p>
                    <div class="PlaceholdersList">
                        <ul>
                            <li>[CHARA-FIRSTNAME]</li>
                            <li>[CHARA-MIDDLENAME]</li>
                            <li>[CHARA-LASTNAME]</li>
                            <li>[CHARA-FULLNAME]</li>
                            <li>[CHARA-DISPLAYIMAGE]</li>
                            <li>[CHARA-GENDER]</li>
                            <li>[CHARA-SEXUALITY]</li>
                        </ul>
                    </div>
                    <p><strong>Link-Related</strong></p>
                    <div class="PlaceholdersList">
                        <ul>
                            <li>[LINK-HOME]</li>
                            <li>[LINK-SENDMESSAGE]</li>
                            <li>[LINK-VIEWGALLERY]</li>
                        </ul>
                    </div>
                    <p><strong>Other Functions</strong></p>
                    <ul>
                        <li>[FUNC-MATURENOTICE]</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
