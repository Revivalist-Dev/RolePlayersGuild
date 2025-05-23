<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditUniverse.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditUniverse" ClientIDMode="Static" %>
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
        <a class="btn btn-default" href="/My-Universes/">Back to My Universes</a>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:HyperLink ID="lnkViewUniverse" runat="server" CssClass="btn btn-default" NavigateUrl="#" Target="_blank">View Universe</asp:HyperLink>
    </div>
</div>
    <div class="alert alert-notice small"><strong>Please Note:</strong> By creating this Universe, you agree and understand that your Writer Profile will be publicly displayed on the Universe’s information page. Using code of any kind to hide this information is not allowed and will result in a deletion of your Universe without warning.</div>

<div class="form-group">
    <label for="txtUniverseName">Universe Name</label>
    <asp:TextBox ID="txtUniverseName" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Universe Name (Required)" required autofocus MaxLength="50"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvUniverseName" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a name for the universe." ControlToValidate="txtUniverseName" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
</div>

<div class="form-group">
    <label for="txtUniverseDescription">Universe Description</label>
    <asp:TextBox ID="txtUniverseDescription" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" placeholder="Try to include enough information about the universe that it interests people, but not so much that it's a chore to read." ValidateRequestMode="Disabled" Rows="12"></asp:TextBox>
</div>
<div class="form-group clearfix">
    <label for="cblGenres">Genres</label>
    <div class="FancyCheckList GenreList">
        <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" CssClass="FancyCheck" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
    </div>
</div>

<div class="form-group">
    <label for="ddlSource">Content Source</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlSource" runat="server" CssClass="form-control">
            <asp:ListItem Text="Fan-Fic" Value="2"></asp:ListItem>
            <asp:ListItem Text="Original" Value="1"></asp:ListItem>
        </asp:DropDownList>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#SourceDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
    <div class="alert alert-notice small"><strong>Please Note:</strong> Fan-Fic Universes must have valid links to legitimate sources. Fan-Fic Universes lacking proper citation may be deleted without warning.</div>

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
<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkDisableLinkify" ClientIDMode="Static" runat="server" Text="Disable auto-spacing and linking." />
</div>

<%--<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkRequireApprovalOnJoin" ClientIDMode="Static" runat="server" Text="Anyone who wants to join this universe must be approved by me." />
</div>
--%>

<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink ID="lnkDeleteUniverse" runat="server" Text="Delete Universe" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteUniverseModal" />
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnCreateUniverse" runat="server" Text="Save Universe" CssClass="btn btn-primary" OnClick="btnCreateUniverse_Click" />
    </div>
</div>

<!-- Modals -->
<div class="modal fade" id="GenreList" tabindex="-1" role="dialog" aria-labelledby="GenreListLabel">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="GenreListLabel">Select Genres</h4>
            </div>
            <div class="modal-body FancyCheckList">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="SourceDescription" tabindex="-1" role="dialog" aria-labelledby="SourceLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="SourceLabel">Content Sources</h4>
            </div>
            <div class="modal-body">
                <p>Content sources can be defined as so:</p>
                <ul>
                    <li><strong>Fan-Fic:</strong>
                        Universes that the writer did not originally create.
                    </li>
                    <li><strong>Original:</strong>
                        Universes that are completely original creations of the writer creating this listing writer.
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
<div class="modal fade" id="DeleteUniverseModal" tabindex="-1" role="dialog" aria-labelledby="DeleteUniverseLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="DeleteUniverseLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this universe?</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDeleteUniverse" runat="server" Text="Delete Universe" CssClass="btn btn-danger" OnClick="btnDeleteUniverse_Click" />

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>
