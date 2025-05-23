<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditStory.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditStory" ClientIDMode="Static" %>
<script src="/js/jquery.are-you-sure.js"></script>
<script src="/js/ays-beforeunload-shim.js"></script>
<script>
    $(function () {
        $('#form1').areYouSure();
    });

</script>
<asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
    <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
</asp:Panel>
<h1>
    <asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <a class="btn btn-default" href="/My-Stories/">Back to My Stories</a>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:HyperLink ID="lnkViewStory" runat="server" CssClass="btn btn-default" NavigateUrl="#" Target="_blank">View Story</asp:HyperLink>
    </div>
</div>

<div class="form-group">
    <label for="txtStoryTitle">Story Title</label>
    <asp:TextBox ID="txtStoryTitle" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="(Required)" required autofocus MaxLength="50"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvStoryTitle" SetFocusOnError="true" runat="server" ErrorMessage="You must enter a name for the Story." ControlToValidate="txtStoryTitle" Display="Dynamic" CssClass="label label-danger"></asp:RequiredFieldValidator>
</div>

<div class="form-group">
    <label for="txtStoryDescription">Story Description</label>
    <asp:TextBox ID="txtStoryDescription" runat="server" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-control" ValidateRequestMode="Disabled" Rows="12"></asp:TextBox>
</div>

<div class="form-group">
    <label for="ddlUniverse">Universe</label>
    <asp:DropDownList ID="ddlUniverse" runat="server" CssClass="form-control" DataSourceID="sdsUniverses" DataTextField="UniverseName" DataValueField="UniverseID" AppendDataBoundItems="true">
        <asp:ListItem Value="0" Text="No Universe Selected"></asp:ListItem>
    </asp:DropDownList>
    <asp:SqlDataSource ID="sdsUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [UniverseID], [UniverseName]  FROM [Universes] Where UniverseOwnerID = @WriterID ORDER BY [UniverseName]">
        <SelectParameters>
            <asp:SessionParameter Type="Int32" SessionField="UserID" Name="WriterID" />
        </SelectParameters>
    </asp:SqlDataSource>
</div>

<div class="form-group">
    <label for="ddlRating">Content Rating</label>
    <div class="input-group">
        <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control">
            <asp:ListItem Text="Teen" Value="1"></asp:ListItem>
            <asp:ListItem Text="Mature" Value="2"></asp:ListItem>
            <asp:ListItem Text="Adults-Only" Value="3"></asp:ListItem>
        </asp:DropDownList>
        <span class="input-group-btn">
            <a href="#" data-toggle="modal" data-target="#RatingDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
        </span>
    </div>
</div>
<div class="form-group clearfix">
    <label for="cblGenres">Genres</label>
    <div class="FancyCheckList GenreList">
        <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" CssClass="FancyCheck" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
        <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
    </div>
</div>
<div class="checkbox FancyCheck">
    <asp:CheckBox ID="chkPrivateStory" ClientIDMode="Static" runat="server" Text="This Story should not be listed publicly." />
</div>

<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <asp:HyperLink ID="lnkDeleteStory" runat="server" Text="Delete Story" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteStoryModal" />
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnCreateStory" runat="server" Text="Save Story" CssClass="btn btn-primary" OnClick="btnCreateStory_Click" />
    </div>
</div>

<!-- Modals -->

<div class="modal fade" id="DeleteStoryModal" tabindex="-1" role="dialog" aria-labelledby="DeleteStoryLabel" runat="server" clientidmode="Static">
    <div class="modal-dialog" role="document">
        <div class="modal-content alert-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="DeleteStoryLabel">Are you sure?</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this Story?</p>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnDeleteStory" runat="server" Text="Delete Story" CssClass="btn btn-danger" OnClick="btnDeleteStory_Click" />

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
                    <li><strong>Adults-Only:</strong>
                        Content is not suitable for anyone under 18. May contain explicit and uncensored content.
                    </li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
