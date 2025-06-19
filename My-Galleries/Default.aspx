<%@ Page Title="My Galleries on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyGalleries.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>



<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:ListView ID="lvGalleries" runat="server" GroupItemCount="3" DataSourceID="sdsGalleries" OnItemDataBound="lvGalleries_ItemDataBound">
        <LayoutTemplate>
            <fieldset class="MyGalleryList">
                <legend>My Galleries</legend>
                <div runat="server" id="groupPlaceholder">
                </div>
            </fieldset>
        </LayoutTemplate>
        <GroupTemplate>
            <%--<div class="row row-eq-height">--%>
                <div runat="server" id="itemPlaceholder"></div>
            <%--</div>--%>
        </GroupTemplate>
        <ItemTemplate>
            <div class="Item col-xl-2 col-lg-3 col-sm-4 col-xs-6">
                <label><span runat="server" id="spanImageCommentBadge" class="badge" visible="false"></span><%# Eval("CharacterDisplayName") %></label>
                <a href="/Gallery?id=<%# Eval("CharacterID") %>" class="Image thumbnail" style="background-image: url(<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>)">
                    <%--<img class="lazyload" src="<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>" data-src="<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "full") %>" />--%>
                </a>
                <%--<span><a href="/My-Galleries/Edit-Gallery?Mode=Edit&GalleryID=<%# Eval("CharacterID") %>">Edit Gallery</a></span>--%>
                <div class="ButtonPanel">
                    <a class="btn btn-default" href="/Gallery?id=<%# Eval("CharacterID") %>">
                        <span class="glyphicon glyphicon-eye-open"></span>
                        View</a>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <asp:SqlDataSource ID="sdsGalleries" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], [CharacterDisplayName], [DisplayImageURL], (Select Count(ImageCommentID) From ImageCommentsWithDetails Where IsRead = 0 And ImageOwnerCharacterID = CharactersWithDisplayImages.CharacterID) As UnreadCommentCount FROM [CharactersWithDisplayImages] WHERE ([UserID] = @UserID)">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
