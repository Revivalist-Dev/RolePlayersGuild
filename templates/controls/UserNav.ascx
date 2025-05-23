<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserNav.ascx.cs" Inherits="RolePlayersGuild.templates.controls.UserNav" %>

<script>

    setInterval(GetCounts, 60000);
    function GetCounts() {
        var ThePost = $.post("/templates/controls/endpoints/GetNotificationCounts.aspx", { UserID: <%=UserID%> });
        ThePost.done(function (data) {
            var ThreadCount = $(data).find("#UnreadThreads")[0].innerHTML.trim();
            var ImageCommentCount = $(data).find("#UnreadImageComments")[0].innerHTML.trim();
            if (ThreadCount.length > 0)
            {
                $("#aMyThreads").show();
                $("#aMyThreads").empty().html("Unread Threads " + ThreadCount);
            }
            
            if (ImageCommentCount.length > 0)
            {
                $("#aMyGalleries").show();
                $("#aMyGalleries").empty().html("Unread Gallery Comments " + ImageCommentCount);
            }
        })
    }

    //$(function() { GetCounts(); });
</script>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">Quick Links</h3>
    </div>
    <div class="list-group">
        <a class="list-group-item list-group-item-info" style="display: none;" href="/My-Galleries/" id="aMyGalleries">My Galleries </a>
        <a class="list-group-item list-group-item-info" style="display: none;" href="/My-Threads/Unread-Threads/" id="aMyThreads">My Threads</a>
        <a class="list-group-item list-group-item-info" runat="server" id="aAdminConsole" visible="false" href="/Admin/">Admin Console</a>
        <asp:Repeater runat="server" ID="rptQuickLinks" DataSourceID="sdsQuickLinks">
            <ItemTemplate>
                <a class="list-group-item" href="<%# Eval("LinkAddress") %>"><%# Eval("LinkName") %></a>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="sdsQuickLinks" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [QuickLinks] WHERE ([UserID] = @UserID) Order By OrderNumber, LinkName">
            <SelectParameters>
                <asp:Parameter Name="UserID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</div>
<div class="panel panel-primary" runat="server" id="divThreadFolders" visible="false">
    <div class="panel-heading">
        <h3 class="panel-title">Thread Folders</h3>
    </div>
    <div class="list-group">
        <a class="list-group-item" href="/My-Threads/">All Threads</a>
        <a class="list-group-item" href="/My-Threads/Unread-Threads/">Unread Threads</a>
        <a class="list-group-item" href="/My-Threads/Abandoned-Threads/">Abandoned Threads</a>
    </div>
</div>
<div class="panel panel-primary" runat="server" id="divStoryNav" visible="false">
    <div class="panel-heading">
        <h3 class="panel-title">Story Info</h3>
    </div>
    <div class="list-group">
        <a class="list-group-item" href="/Story/?id=" runat="server" id="aStoryDescription">Story Description</a>
        <a class="list-group-item" href="/Writer/?id=" runat="server" id="aContactOwner">Contact Owner</a>
        <a class="list-group-item" href="/Story/Posts/?storyid=" runat="server" id="aPosts">Posts</a>
    </div>
</div>
