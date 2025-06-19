<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditImage.ascx.cs" Inherits="RolePlayersGuild.templates.controls.EditImage" ClientIDMode="Static" %>
<%@ Register Src="~/templates/controls/subcontrols/ImageUploadAccordionItem.ascx" TagPrefix="uc1" TagName="ImageUploadAccordionItem" %>


<h1>
    <asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
<%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>--%>
<%--<label for="rblImagesToUpload">How many images?</label>--%>
<%--<p class="small">Please note that if you begin to upload images, then change the amount, all your previously selected images will be removed.</p>--%>
<%--<div class="SelectableCharacterList MyCharactersForThread">
            <asp:RadioButtonList ID="rblImagesToUpload" ClientIDMode="Static" runat="server" RepeatLayout="UnorderedList" OnSelectedIndexChanged="rblImagesToUpload_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem>1</asp:ListItem>
                <asp:ListItem>5</asp:ListItem>
                <asp:ListItem>10</asp:ListItem>
            </asp:RadioButtonList>
        </div>--%>
<asp:Panel runat="server" class="rpgAccordion panel-group" ID="pnlImageAccordion" ClientIDMode="Static">
    <asp:PlaceHolder runat="server" ID="phAccordion"></asp:PlaceHolder>
</asp:Panel>
<%--    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="rblImagesToUpload" EventName="SelectedIndexChanged" />
    </Triggers>
</asp:UpdatePanel>--%>
<asp:Panel runat="server" ID="pnlEditImage" Visible="false">
    <asp:Panel runat="server" ID="pnlProfileImage" class="form-group">
        <label for="fuCharacterProfileImage">Display Image</label>
        <asp:FileUpload ID="fuCharacterProfileImage" runat="server" />
    </asp:Panel>
    <p class="help-block"><strong class="text-danger">NOTE:</strong> Please do <strong>not</strong> upload images with mature content. Violation of this rule may result in full account deletion without warning.</p>
    <div class="form-group">
        <label for="txtCaption">Image Caption</label>
        <asp:TextBox ID="txtCaption" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="You can be creative with your caption! Type as much as you like!" autofocus TextMode="MultiLine" Rows="4"></asp:TextBox>
    </div>

    <label for="chkMatureContent">Display Image?</label>
    <div class="checkbox">
        <label>
            <asp:CheckBox ID="chkMakePrimary" ClientIDMode="Static" runat="server" Text="" />
            Make this image my display image.
        </label>

    </div>

    <%--    <label for="chkMatureContent">Mature Content?</label>

    <div class="checkbox">
        <label>
            <asp:CheckBox ID="chkMatureContent" ClientIDMode="Static" runat="server" Text="" />
            This image is intended for mature audiences only.
        </label>
    </div>--%>
</asp:Panel>
<div class="ButtonPanel clearfix">
    <div class="col-xl-3 col-sm-4 col-xs-12">
        <%--<asp:Button ID="btnAddAccordionItem" runat="server" Text="Add Image" CssClass="btn btn-success" OnClick="btnAddAccordionItem_Click" />--%>
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12">
    </div>
    <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
        <asp:Button ID="btnAddImage" runat="server" Text="Save Images" CssClass="btn btn-primary" OnClick="btnAddImage_Click" />
    </div>
</div>

