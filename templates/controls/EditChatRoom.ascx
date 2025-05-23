<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditChatRoom.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditChatRoom" ClientIDMode="Static" %>
<script src="/js/jquery.are-you-sure.js"></script>
<script src="/js/ays-beforeunload-shim.js"></script>
<script>
    $(function () {
        // Example 1 - ... in one line of code
        $('#form1').areYouSure();
    });
    <%--    $(document).ready(function () {
        $('#<%= cblGenres.ClientID %> input[type=checkbox]').change(
        function () {
            var GenreList = '';
            $('#<%= cblGenres.ClientID %> input:checked').each(function () {
                GenreList += $(this).next('label').text() + ', ';
            });
            $('#spnGenreList').text(GenreList.slice(0, -2));
        });
    });--%>
</script>
<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>
<h1>
    <asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <a class="btn btn-default" href="/My-Chat-Rooms/">Back to My Chat Rooms</a>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
    </div>
</div>
    <div class="alert alert-notice small"><strong>Please Note:</strong> By creating this Chat Room, you agree and understand that your Writer Profile will be publicly displayed on the Chat Room’s details section. Using code of any kind to hide this information is not allowed and will result in a deletion of your Chat Room without warning.</div>

<div class="form-group">
    <label for="txtChatRoomName">Chat Room Name</label>
    <asp:TextBox ID="txtChatRoomName" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Chat Room Name (Required)" required autofocus MaxLength="50"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvChatRoomName" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a name for the Chat Room." ControlToValidate="txtChatRoomName" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
</div>

<div class="form-group">
    <label for="txtChatRoomDescription">Chat Room Description</label>
    <asp:TextBox ID="txtChatRoomDescription" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="Try to include enough information about the Chat Room that it interests people, but not so much that it's a chore to read." ValidateRequestMode="Disabled" Rows="12"></asp:TextBox>
</div>
<div class="form-group">
    <label for="ddlRating">Content Rating</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control">
            <asp:ListItem Text="Teen" Value="1"></asp:ListItem>
            <asp:ListItem Text="Mature" Value="2"></asp:ListItem>
        </asp:DropDownList>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#RatingDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
<div class="form-group">
    <label for="ddlUniverse">Universe</label>
    <asp:DropDownList ID="ddlUniverse" runat="server" CssClass="form-control" DataSourceID="sdsUniverses" DataTextField="UniverseName" DataValueField="UniverseID" AppendDataBoundItems="true">
        <asp:ListItem Text="OOC" Value="0"></asp:ListItem>
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [UniverseID], [UniverseName] FROM [Universes] Where UniverseOwnerID = @WriterID ORDER BY [UniverseName]">
        <SelectParameters>
            <asp:SessionParameter Type="Int32" SessionField="UserID" Name="WriterID" />
        </SelectParameters>
    </asp:SqlDataSource>
</div>

<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink ID="lnkDeleteChatRoom" runat="server" Text="Delete Chat Room" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteChatRoomModal" />
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnCreateChatRoom" runat="server" Text="Save Chat Room" CssClass="btn btn-primary" OnClick="btnCreateChatRoom_Click" />
    </div>
</div>

<!-- Modals -->

<div class="modal fade" id="DeleteChatRoomModal" tabindex="-1" role="dialog" aria-labelledby="DeleteChatRoomLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="DeleteChatRoomLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this Chat Room?</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDeleteChatRoom" runat="server" Text="Delete Chat Room" CssClass="btn btn-danger" OnClick="btnDeleteChatRoom_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="RatingDescription" tabindex="-1" role="dialog" aria-labelledby="RatingLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="RatingLabel">Content Ratings</h4>
            </div>
            <div class="modal-body">
                <p>Content ratings can be defined as so:</p>
                <ul>
                    <li><strong>Teen:</strong>
                        Content is generally suitable for ages 13 and up. May contain violence, suggestive themes, crude humor, minimal blood, simulated gambling and/or infrequent use of strong language.
                    </li>
                    <li><strong>Mature:</strong>
                        Content is generally suitable for ages 17 and up. May contain intense violence, blood and gore, sexual content and/or strong language.
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
